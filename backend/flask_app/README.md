## Database and Chat Creation Service

This service is responsible for the Database and Chat Creation

Due to time constraints of the Hackathon, currently it stores the chat __in memory__ but it can easily be extended to be store it inside of an actual database. 

Also currently there is __global__ chats, as we didn't have time to implement authentication into the system. The routes can easily be modified to check for a JWT/Session Token and then return user specific output.

### How to Start

#### Step 1: Create a virtual environment and activate it

```bash
pip install virtualenv

virtualenv my_env

my_env/Scripts/activate
```

#### Step 2: Install the requirements

```bash
pip install -r requirements.txt
```

#### Step 3: Run the flask application

```bash
python server.py
```


### API Routes

1. __/api/chats__:

Methods : __GET__ and __POST__

For __GET__ method:

It returns the chat information of all the chats. Currently returns all chats inside of the system.  

Can be modified to returning user specific chats easily by adding a Auth Token in the payload

Example:
```bash
chats = [
    {
      "chat_id": "qdI5if7aROU1",
      "chat_name": "Test DB Chat",
      "database": "test",
      "dbms": "postgresql",
      "environment": "local",
      "host_name": "localhost",
      "password": "postgres",
      "port": "5432",
      "user": "postgres"
    },
    {
      "chat_id": "iZWrhq2rQc0L",
      "chat_name": "Users DB Chat",
      "database": "pulzion",
      "dbms": "postgresql",
      "environment": "local",
      "host_name": "localhost",
      "password": "postgres",
      "port": "5432",
      "user": "postgres"
    }
]

```

For __POST__ method:

It creates a new chats resource in the system. Takes the input credentials necessary for connecting to a database

Input payload
```bash
{
    chat_name: string,
    host_name: string,
    port:string,
    user:string,
    password:string,
    database:string,  # Database name
    dbms:string ("postgresql"),
    environment: string ("local", "cloud")
}
```

2. __/api/chats/<chat_id>__

Methods: __GET__ and __POST__

For __GET Method__:

The API Endpoint returns the chat history of that particular chat

Return payload is as follows:

```bash
{
    chat_history: [
        {
            "role": "user",
            "content" : "... some prompt",
            "content_type" : "text"
        },
        {
            "role": "assistant",
            "content" : "...",
            "content_type" : "table" | "text" | "query" | "image"  
        },
        ...
    ]
}
```

If the `content-type` is `table` then the output data structure is: `Array -> Dict -> ColName:Value`

Example:
```
[
    {
        col1:val1,
        col2:val2,
        col3:val3
    },
    {
        col1:val4,
        col2:val5,
        col3:val6
    },
    {
        col1:val7,
        col2:val8,
        col3:val9
    }
]
```
This results in table:
<table>
    <thead>
        <tr>
            <td>col1<td>
            <td>col2<td>
            <td>col3<td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>val1<td>
            <td>val2<td>
            <td>val3<td>
        </tr>
        <tr>
            <td>val4<td>
            <td>val5<td>
            <td>val6<td>
        </tr>
        <tr>
            <td>val7<td>
            <td>val8<td>
            <td>val9<td>
        </tr>
    </tbody>
</table>

 
For __POST Method__:

The API Endpoint takes input a message and stores it inside the chat history of the particular chat

Input payload

```bash
{
    "role": "user" | "assistant",
    "content": "...",
    "content_type": "table" | "text" | "query" | "image"  
}
```

3. __/api/chats/<chat_id>/credentials__

methods: __GET__

This api end points provides the credentials of a particular chat room.
Note: Currently there are no security measures in-place to check the ownership of the particular chat, but it can easily be implemented simply by mapping `uid` to `chat_id` inside the database


Example output:
```bash
{
    "chat_id": "iZWrhq2rQc0L",
    "chat_name": "Users DB Chat",
    "database": "pulzion",
    "dbms": "postgresql",
    "environment": "local",
    "host_name": "localhost",
    "password": "postgres",
    "port": "5432",
    "user": "postgres"
}
```

4. __/api/chats/<chat_id>/replication-file__

Methods: __POST__

This API Endpoint takes input the replication file created using the following command

```
pg_dump -F p -U <user> -d <db-name> -f replica.sql
```
This file is extracted from a form data where the key is `file` and value is the replica file

It extracts the credentials by using __chat_id__  and using those credentials, it spins up a __docker container__

This docker container runs a `postgres` image and replicates the database using __replica.sql__ file

Note: the following command `time.sleep(3)` is used inside the endpoint as it takes time before the docker container is ready. It may vary depending on the type of machine the server is running on

