from firebase_admin import storage, credentials, initialize_app
from firebase_admin import credentials
import uuid

cred = credentials.Certificate("app/services/firebase_services/data/firebase-config.json")
initialize_app(cred, {
    'storageBucket': 'pulzion-app.appspot.com'
})

def store_to_firebasebase(img_buffer, file_name):
    unique_file_name = f"image_{uuid.uuid4()}.png"
    bucket = storage.bucket()
    blob = bucket.blob(unique_file_name)
    blob.upload_from_file(img_buffer, content_type='image/png')
    blob.make_public()

    public_url = blob.public_url
    print(f"File uploaded successfully: {public_url}")
    return public_url
    