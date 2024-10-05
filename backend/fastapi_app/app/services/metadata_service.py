from langchain_community.utilities.sql_database import SQLDatabase
from ..config import *


def generate_metadata(queries, connection_uri, dbms):
    try:
        db = SQLDatabase.from_uri(connection_uri)

        database_metadata = {
            "number_of_tables": 0,
            "number_of_views": 0,
            "number_of_procedures": 0,
            "procedures": {},
            "tables": {},
            "views": [],
            "dbms used" : dbms
        }

        tables_result = db._execute(queries["Tables"])
        database_metadata["number_of_tables"] = len(tables_result)
        
        columns_result = db._execute(queries["Columns"])
        primary_keys = db._execute(queries["Primary Keys"])
        foreign_keys = db._execute(queries["Foreign Keys"])
        indexes = db._execute(queries["Indexes"])
        
        table_columns = {}
        for column in columns_result:
            table_name = column["table_name"]
            column_name = column["column_name"]
            
            if table_name not in table_columns:
                table_columns[table_name] = {"columns": {}, "number_of_columns": 0}
            
            is_primary = any(pk["column_name"] == column_name and pk["table_name"] == table_name for pk in primary_keys)
            
            is_indexed = any(
                column_name in idx["indexdef"] and idx["tablename"] == table_name
                for idx in indexes
            )
            
            referenced_tables = [
                fk["referenced_table"] for fk in foreign_keys 
                if fk["source_table"] == table_name and fk["source_column"] == column_name
            ]
            is_foreign = len(referenced_tables) > 0
            
            table_columns[table_name]["columns"][column_name] = {
                "isPrimaryKey": is_primary,
                "isIndexed": is_indexed,
                "isForeignKey": is_foreign,
                "ReferencedTableNames": referenced_tables
            }
            table_columns[table_name]["number_of_columns"] += 1
        
        database_metadata["tables"] = table_columns

        views_result = db._execute(queries["Views"])
        database_metadata["number_of_views"] = len(views_result)
        for view in views_result:
            database_metadata["views"].append({
                "view_name": view["table_name"],
                "view_definition": view["view_definition"]
            })
        
        procedures_result = db._execute(queries["Procedures"])
        procedure_parameters_result = db._execute(queries["Procedure Parameters"])
        database_metadata["number_of_procedures"] = len(procedures_result)
        
        for procedure in procedures_result:
            routine_name = procedure["routine_name"]
            routine_definition = procedure["routine_definition"]
            
            parameters = [
                {
                    "parameter_name": param["parameter_name"],
                    "data_type": param["data_type"],
                    "parameter_mode": param["parameter_mode"]
                }
                for param in procedure_parameters_result 
                if param["specific_name"] == routine_name
            ]
            
            database_metadata["procedures"][routine_name] = {
                "parameters": parameters,
                "routine_definition": routine_definition
            }

        return database_metadata

    except Exception as e:
        return {"error" : f"An error occurred: {e}"}
