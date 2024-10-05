## Next JS Web Frontend

We have used Next JS to create our front end application for the web

### How to run

#### Step 1: Configure the credentials

Create a `.env` file in the frontend folder

Then input the values to the following environment variables.

```bash
FLASK_APP_URL=
NEXT_APP_URL=
FAST_API_APP_URL=
```

Refer: `.env.demo` file for more information

#### Step 2: Install required packages

Run the following command to install packages

```bash
npm install
```

#### Step 3: Run the server

```bash
npm run dev
```

### How to use

The root route __'/'__ is not designed as we were going to add authentication in the page.
However due to time constraints of the hackathon, we were not able to implement authentication in this project

Goto __'/new-chat'__ route which will let you create a new chat by providing necessary credentials of the database

After creating a new chat, you will be able to send prompts in natural language.

When the result table is obtained, you can click the `Insights` button to get the graphs and other information from the backend.