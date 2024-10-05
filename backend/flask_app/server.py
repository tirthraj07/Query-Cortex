from flask import Flask, jsonify, request, json
import secrets
import string
from collections import defaultdict
import os
import subprocess
import random
import time
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = './uploads/'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

chats = []

history = defaultdict(list)

def get_credentials(chat_id):
    for i in range (0, len(chats)):
        if chats[i]['chat_id'] == chat_id:
            return chats[i]
    return None

def generate_chat_id(length=12):
    characters = string.ascii_letters + string.digits  # A-Z, a-z, 0-9
    return ''.join(secrets.choice(characters) for _ in range(length))

@app.route('/api/chats',methods=['GET','POST'])
def chatApiRoute():
    if request.method == 'POST':

        data = request.get_json()

        required_fields = ['chat_name', 'host_name', 'port', 'user', 'password', 'database', 'dbms', 'environment']
        missing_fields = [field for field in required_fields if field not in data]

        if missing_fields:
            return jsonify({"error": f"Missing fields: {', '.join(missing_fields)}"}), 400

        chat_name = data.get('chat_name')
        host_name = data.get('host_name')
        port = data.get('port')
        user = data.get('user')
        password = data.get('password')
        database = data.get('database')
        dbms = data.get('dbms')
        environment = data.get('environment')

        chat_id = generate_chat_id()
        credentials = {
            'chat_id': chat_id,
            'chat_name': chat_name,
            'database': database,
            'dbms': dbms,
            'environment': environment,
            'host_name': host_name,
            'password': password,
            'port': port,
            'user': user
        }

        chats.append(credentials)

        print(f"Received Create Chat Request for: {chat_name} {host_name} {port} {user} {password} {database} {dbms} {environment}")
        
        return jsonify({"success": "Data received successfully", "chat_id":chat_id}), 201

    else:
        return jsonify({"chats":chats}), 200

history = defaultdict(list)
@app.route('/api/chats/<chat_id>', methods=['GET', 'POST'])
def chatHistoryRoute(chat_id):
    if request.method == "GET":
        chat_history = history.get(chat_id, [])
        return jsonify({"chat_history":chat_history}), 200

    elif request.method == "POST":
        data = request.get_json()
        role = data.get('role')
        content = data.get('content')
        content_type = data.get('content_type')
        if role and content:
            history[chat_id].append({
                "role": role,
                "content": content,
                "content_type":content_type
            })
            return jsonify({"success": "Chat message stored successfully"}), 201
        else:
            return jsonify({"error": "Invalid input"}), 400


@app.route('/api/chats/<chat_id>/credentials', methods=['GET'])
def chatCredentials(chat_id):
    creds = get_credentials(chat_id)
    if creds is not None:
        return jsonify(creds), 200
    else:
        return jsonify({"error": "Chat not found"}), 404

def get_random_port():
    return random.randint(10000, 30000)

def update_chat(chats, chat_id, updated_user, updated_port):
    for chat in chats:
        if chat['chat_id'] == chat_id:
            chat['user'] = updated_user
            chat['port'] = updated_port
            print(f"Updated chat with chat_id {chat_id}: user={updated_user}, port={updated_port}")
            return chat
    print(f"No chat found with chat_id {chat_id}")
    return None

@app.route('/api/chats/<chat_id>/replication-file', methods=['POST'])
def upload(chat_id):
    file = request.files.get('file')
    if file:
        print(file.filename)
    else:
        print("File not found")

    if file and file.filename.endswith('.sql'):
        file_name = f"{chat_id}.sql"  # Create a file name using the chat_id
        filepath = os.path.join(UPLOAD_FOLDER, file_name)

        try:
            file.save(filepath)  # Save the uploaded file
            container_name = f"postgres_{chat_id}"
            chat_credentials = get_credentials(chat_id)

            if chat_credentials is None:
                return jsonify({"error":"Chat Credentials not found"}), 404


            postgres_password = str(chat_credentials['password'])
            postgres_db_name = str(chat_credentials['database'])
            random_port = get_random_port()


            print(f"postgres_{chat_id} : {postgres_password}")
            print(f"Database Name: {postgres_db_name}")
            print(f"Starting on Port: {random_port}")

            absolute_filepath = os.path.abspath(filepath)
            print(absolute_filepath)
            
            start_container_cmd = [
                "docker", "run", "-d", "--name", container_name,
                "-e", f"POSTGRES_PASSWORD={postgres_password}",
                "-e", f"POSTGRES_DB={postgres_db_name}",
                "-p", f"{random_port}:5432",
                "postgres"  # Docker image
            ]

            subprocess.run(start_container_cmd, check=True)

            print("Container Started")

            # 2. Copy the backup.sql file into the container
            copy_backup_cmd = [
                "docker", "cp", absolute_filepath,
                f"{container_name}:/backup.sql"  # Destination inside the container
            ]

            subprocess.run(copy_backup_cmd, check=True)

            print("File Transferred")

            # 3. (Optional) Restore the backup inside the container
            # Note: You can uncomment this section if you want to restore the database immediately.
            time.sleep(3)

            restore_backup_cmd = [
                "docker", "exec", container_name,
                "psql", "-U", "postgres", "-d", postgres_db_name, "-f", "/backup.sql"
            ]
            subprocess.run(restore_backup_cmd, check=True)
            
            print("Restoration complete")

            update_chat(chats, chat_id, 'postgres', str(random_port))

            return jsonify({"success": "Container started and SQL file mounted for restoration"}), 200
        
        except Exception as e:
            return {"error": f"Error saving file: {str(e)}"}, 500
        
        

    return {"message": "Invalid file type, only .sql files are allowed"}, 400


if __name__ == '__main__':
    app.run(port=8080, debug=True)

