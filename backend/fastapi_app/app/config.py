db_user = "postgres"
db_password = "Amey1234"
db_host = "localhost"
db_name = "fastapi_db"
db_port = '5432'

connection_uri = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
# Define and execute queries
queries = {
        "Tables": f"""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public';
        """,
        
        "Views": f"""
            SELECT table_name, view_definition 
            FROM information_schema.views
            WHERE table_schema = 'public';
        """,
        
        "Procedures": f"""
            SELECT routine_name, routine_definition
            FROM information_schema.routines
            WHERE routine_schema = 'public' 
              AND routine_type = 'PROCEDURE';
        """,
        
        "Procedure Parameters": f"""
            SELECT specific_name, parameter_name, data_type, parameter_mode
            FROM information_schema.parameters
            WHERE specific_schema = 'public';
        """,
        
        "Columns": f"""
            SELECT table_name, column_name, data_type, is_nullable, column_default
            FROM information_schema.columns 
            WHERE table_schema = 'public';
        """,
        
        "Primary Keys": f"""
            SELECT kcu.table_name, kcu.column_name
            FROM information_schema.key_column_usage kcu
            JOIN information_schema.table_constraints tc 
              ON kcu.constraint_name = tc.constraint_name
            WHERE tc.constraint_type = 'PRIMARY KEY'
              AND kcu.table_schema = 'public';
        """,
        
        "Foreign Keys": f"""
            SELECT 
                kcu.table_name AS source_table,
                kcu.column_name AS source_column,
                ccu.table_name AS referenced_table,
                ccu.column_name AS referenced_column
            FROM 
                information_schema.key_column_usage kcu
            JOIN 
                information_schema.table_constraints tc 
                ON kcu.constraint_name = tc.constraint_name
            JOIN 
                information_schema.constraint_column_usage ccu 
                ON ccu.constraint_name = tc.constraint_name
            WHERE 
                tc.constraint_type = 'FOREIGN KEY'
                AND kcu.table_schema = 'public';
        """,
        
        "Indexes": f"""
            SELECT 
                schemaname,
                tablename,
                indexname,
                indexdef
            FROM 
                pg_indexes
            WHERE 
                schemaname = 'public';
        """
    }