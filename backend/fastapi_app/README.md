## Query Processing Service

This service is responsible for the actual conversion of NLP to SQL and generating output data  
 
It utilized two LLMs namely : __Gemini__ and __Worqhat__

### How to start

#### Step 1: Configure the environment variables

Create a `.env` file and input the data accordingly

```bash
WORQHAT_API_KEY=<worqhat-api-key>
GEMINI_API_KEY=<gemini-api-key>
GEMINI_MODEL_NAME=gemini-1.5-flash
```

#### Step 2: Configure firebase credentials

Goto `/app/services/firebase_services/data/firebase-config.json` file and input the given information

```bash
{
    "type": "",
    "project_id": "",
    "private_key_id": "",
    "private_key": "",
    "client_email": "",
    "client_id": "",
    "auth_uri": "",
    "token_uri": "",
    "auth_provider_x509_cert_url": "",
    "client_x509_cert_url": "",
    "universe_domain": ""
}
```

#### Step 3: Create a virtual environment and activate it

```bash
pip install virtualenv

virtualenv my_env

my_env/Scripts/activate
```

#### Step 4: Install the required modules

```bash
pip install -r requirements.txt
```

#### Step 5: Run the fast api server

```bash
fastapi dev .\app\main.py
```


### API Routes

1. __/api/metadata/generate__   
Method: __GET__  

This route is responsible for the Generating the meta-data from the given database

2. __/api/query__  
Method: __POST__

This route is used for actual conversion and execution of the query

Expected payload

```bash
{
  "query": "string",
  "model": "string",
  "dbms": "string",
  "credentials": {
    "host": "string",
    "user": "string",
    "password": "string",
    "database": "string",
    "port": "string"
  }
}
```

3. __/api/data-visualization__
Method: __POST__

This method is responsible for the creation of the graphs, charts and insights

Expected payload is the results of the `/api/query` API Endpoint

```bash
{
  "results": [
    "string"
  ]
}
```