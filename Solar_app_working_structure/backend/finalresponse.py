from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, auth, firestore
from flask_cors import CORS
import traceback

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Initialize Firebase Admin
path = r"C:\ws\Recent working\now\Solar_Application\custom_claim\datakey.json"
cred = credentials.Certificate(path)
firebase_admin.initialize_app(cred)
db = firestore.client()

# ✅ 1. Register user (Auth + Firestore + Custom Claim)
@app.route('/register', methods=['POST'])
def register_user():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        role = data.get('role')

        if not all([email, password, role]):
            return jsonify({'error': 'Missing required fields'}), 400

        if role not in ['manufacturer', 'seller']:
            return jsonify({'error': 'Invalid role. Must be "manufacturer" or "seller".'}), 400

        try:
            user = auth.get_user_by_email(email)
            user_created = False
        except auth.UserNotFoundError:
            user = auth.create_user(email=email, password=password)
            user_created = True

        # Set role as custom claim
        auth.set_custom_user_claims(user.uid, {'role': role})

        # Save to Firestore
        db.collection('users').document(user.uid).set({
            'email': email,
            'role': role,
            'uid': user.uid
        })

        return jsonify({
            'message': f'User {email} registered successfully as {role}',
            'uid': user.uid,
            'status': 'success',
            'user_created': user_created
        }), 200

    except Exception as e:
        print("❌ Exception during /register:", str(e))
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500



# ✅ 3. Verify JWT token and return role (or update claim)
@app.route('/verify', methods=['GET'])
def refresh_role_and_token():
    auth_header = request.headers.get('Authorization')

    if not auth_header or not auth_header.startswith('Bearer '):
        return jsonify({'error': 'Missing or invalid Authorization header'}), 401

    id_token = auth_header.split('Bearer ')[1]

    try:
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']
        existing_role = decoded_token.get('role')

        # If custom claim exists
        if existing_role:
            return jsonify({'role': existing_role, 'uid': uid, 'status': 'exists'}), 200

        # Else fetch from Firestore
        doc = db.collection('users').document(uid).get()
        if not doc.exists:
            return jsonify({'error': 'User not found in Firestore'}), 404

        firestore_data = doc.to_dict()
        role = firestore_data.get('role')

        if not role:
            return jsonify({'error': 'Role not found in Firestore'}), 403

        # Update claim
        auth.set_custom_user_claims(uid, {'role': role})

        return jsonify({
            'message': 'Custom claim set',
            'role': role,
            'uid': uid,
            'status': 'claim-updated'
        }), 200

    except Exception as e:
        print("❌ Exception during /verify:", str(e))
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
