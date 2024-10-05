from app.services.database_services.database import Database
from langchain_community.utilities.sql_database import SQLDatabase
from sqlalchemy.exc import SQLAlchemyError

class PostgresLocal(Database):
    def __init__(self, host, user, password, database):
        self.db_user = user
        self.db_password = password
        self.db_host = host
        self.db_name = database
        self.db_port = '5432'
        self.connection_uri = f"postgresql://{user}:{password}@{host}:{self.db_port}/{database}"
        self.db = None

    def connect(self):
        """
        Establishes a connection to the PostgreSQL database using the connection URI.
        """
        try:
            self.db = SQLDatabase.from_uri(self.connection_uri)
            print("Connection to PostgreSQL established successfully.")
        except SQLAlchemyError as e:
            print(f"Error connecting to PostgreSQL: {e}")
    
    def disconnect(self):
        """
        Disconnects from the PostgreSQL database.
        """
        if self.db is not None:
            try:
                # SQLDatabase in LangChain doesn't have a direct close method. 
                # We'll set db to None to simulate closing the connection.
                self.db = None
                print("Disconnected from the PostgreSQL database.")
            except SQLAlchemyError as e:
                print(f"Error during disconnection: {e}")
        else:
            print("No active database connection to close.")
    
    def run_queries(self, queries: list):
        """
        Executes a list of SQL queries and returns the results.
        """
        if self.db is None:
            raise ConnectionError("Database is not connected. Call connect() first.")
        
        results = []
        for query in queries:
            try:
                result = self.db._execute(query)
                results.append(result)
                print(f"Query executed successfully: {query}")
            except SQLAlchemyError as e:
                print(f"Error executing query: {query}, error: {e}")
                results.append(None)
        
        return results