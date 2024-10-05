class PromptProvider:
        
    def generateDescriptionPromptText(self,context_string):
        print(context_string)
        return f"""
        I have provided a JSON structure containing metadata about a database, including tables, views, and procedures. 
        Please analyze the data step by step and return a new JSON structure with the following requirements:

        1. Database Description:
        - Provide a brief description of the overall database, including its purpose and primary functions.

        2. Table Descriptions:
        For each table, generate:
        - A description summarizing the table's purpose.
        - For each column in the table, provide:
            - A description of its role and significance.
        - Analyze relationships with other tables:
            - Provide descriptions of these relationships, including the cardinality (e.g., one-to-many, many-to-one).

        3. View Descriptions:
        For each view, provide:
        - A description of what the view represents.
        - Explain how it relates to the underlying tables and any relevant filters or calculations.

        4. Output Structure:
        - Organize the resulting descriptions clearly within a new JSON format, maintaining clarity and conciseness for each description.

        Processing Steps:
        Please follow these processing steps while analyzing the JSON data:

        1. Overall Database Analysis:
        - Begin with a high-level overview of the database.

        2. Independent Tables:
        - Identify and analyze all independent tables first.
        - For each independent table, repeat the description process as outlined.

        3. Dependent Tables:
        - Identify dependent tables that relate to the independent ones.
        - Repeat the description process for each dependent table accordingly.

        4. Views Analysis:
        - For each view, generate a description based on its definition and context within the database.

        5. Final Output:
        - Ensure the final output is in a well-structured JSON format with clear and concise descriptions.
        - IMPORTANT NOTE: For final output maintain the original metadata and combine it with descriptions
        - IMPORTANT NOTE: Return only the JSON structure and avoid any extra commentary, key points, or explanations

        Here is the JSON data:
        {context_string}
    """

    def generateQueryPromptText(self, query, context_string):
        return f"""
    I am providing you with a JSON structure containing metadata about a database, including tables, columns, relationships, and views. Based on this information, please analyze the following user query and generate the corresponding SQL queries.

    - IMPORTANT NOTE: For any query, do not use any DBMS-specific commands; instead, use nested select queries if required.

    User Query: "{query}"

    Context JSON:
    {context_string}

    Processing Steps:
    1. Analyze the user query step by step to identify the required data elements and relationships based on the provided context.
    2. If the user query can be logically combined into a single SQL query (e.g., queries that involve aggregations like counts and percentages of the same data), please consolidate related components into one comprehensive query.
    3. Ensure that if multiple queries are necessary, they should be distinct based on the user request and should not be combined if they represent different outputs.
    4. Maintain clarity and conciseness while ensuring the correctness of the logic in the queries.

    Examples:
    - **Do's**:
        - If the user asks for the percentage distribution of loans by type and also needs the total count of loans, combine them into one query:
            - **Expected Output**: 
              ```sql
              SELECT loan_type, COUNT(*) AS loan_count, (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans)) AS percentage
              FROM loans
              GROUP BY loan_type
              ```

    - **Don'ts**:
        - Avoid generating separate queries for related data points, such as:
            - **Incorrect Output**:
              ```sql
              SELECT loan_type, COUNT(*) AS loan_count FROM loans GROUP BY loan_type
              SELECT loan_type, (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans)) AS percentage FROM loans GROUP BY loan_type
              ```
        - Instead, return a single comprehensive query that encapsulates both requirements.

    Please generate all necessary SQL queries and return them in a structured JSON format as follows:
    {{
        "queries": [
            {{ "output": " --combined_query " }},
            {{ "output": " --additional_query_if_needed " }}
        ]
    }}

    - IMPORTANT NOTE: Return only the JSON structure and avoid any extra commentary, key points, or explanations.
    - IMPORTANT NOTE: only use dbms specific commands if and only if required. If it is possible with pure sql queries then use that only
    - IMPORTANT NOTE: we are using dbms which is given in "dbms used" key of the context json so make sure the queries are executable in that dbms software
    """

    
    def generateOptimizedQueryPromptText(self,query,context_string):
        prompt = f"""

        Here is the generated SQL query based on the users request:

        -- Original Query
        {query}

        Please optimize this query for better performance, ensuring that the required results remain unchanged.
        - IMPORTANT NOTE: FOR ANY QUERY Do not USE ANY DBMS SPECIFIC COMMAND INSTEAD USE NESTED SELECT QUERIES IF REQUIRED
        I am providing a json structure containing metadata about a database, including tables, columns, relationships, and views which also conatins columns which are indexed
        Use this information to optimize the query.
        {context_string}
        
        Important Instructions:
        Please optimize this query for better performance, ensuring that the required results remain unchanged.
        It is possible that the query doesn't need any optimization. In that case, return the original query
        Return the optimized query in the following JSON format:

        For query with where clause, always create atleast one index if the query is searching on column where index is not created

        IF YOU ARE USING 2 QUERIES TO PRODUCE ONLY ONE PART OF THE ANSWER USE NESTED QUERY INSTEAD OF RETURNING 2 SEPARATE

        {{
            "queries": [
                {{ "optimized_output": " --optimized_query or original sql query if optimization not required " }},
                {{ "optimized_output": " --optimized_query or original sql query if optimization not required " }},
                ...
            ]
        }}


        
        - IMPORTANT NOTE: Return only the JSON structure and avoid any extra commentary, key points, or explanations.
        - IMPORTANT NOTE: only use dbms specific commands if and only if required. If it is possible with pure sql queries then use that only
        - IMPORTANT NOTE: we are using dbms which is given in "dbms used" key of the context json so make sure the queries are executable in that dbms software

        """
        return prompt
    

    def generateVisualizationPromptText(self, results):
        return f"""
    for what ever reason, do not provide me and Explanation, insight, or any other text other than the json output mentioned
    
    I have retrieved multiple datasets from my SQL database, which are presented below. Each dataset corresponds to a different query. Your task is to analyze each dataset and determine the best way to present the information. Specifically:

    1. For each dataset, identify key patterns, trends, or relationships within the data (e.g., correlations, comparisons, distributions).
    2. Based on the analysis of each dataset, recommend whether the data is best represented as a graphical visualization (such as a bar chart, pie chart, line chart, scatter plot, etc.) or a tabular format.
    3. If a graph is suitable, specify the type of chart and explain why it is ideal for the data's structure and insights (e.g., comparing categories, displaying trends, or highlighting proportions).
    4. If a graph is not appropriate, recommend an alternative format (such as a table) and explain why it better conveys the data.
    5. Consider factors like data types (categorical, numerical, etc.), value ranges, and whether the dataset lends itself to comparisons, distributions, or temporal trends.

    **Datasets from SQL query:**
    {results}

    Each dataset in the results array should be processed independently, and appropriate representations should be determined for each.

    STRICTLY FOLLOW RESPONSE FORMAT AND ONLY RETURN PYTHON CODE.

    **Response format:**

    {{
        "response": [
            {{
                "Is graph possible": "true or false",
                "graph type": "-- or 'table' if graph generation not needed",
                "Insights": "This should be a list of insights about the observations of results given",
                "Code": "Return Python code for matplotlib-based visualization or table",
                "data": "Include the data that should be passed to the generate_graph function here"
            }},
            {{
                ...
            }}
        ]
    }}

    **Restrictions on code generation:**

    1. Do not use the `.show()` method to display the image. I want to store the image in Firebase storage instead.
    2. Generate an image buffer from matplotlib and pass it to the function with the filename.
    3. Ensure the filename for each subsequent graph follows a pattern like `graph_1.png`, `graph_2.png`, etc.
    4. Use the following code snippet to execute Firebase logic and store the image:
    5. Append public URLs of stored images to the `image_urls` list (which is pre-defined).
    6. If table generation is preferred, return a blank code string (no Pandas table).
    7. The Python function should return an image buffer to be passed to Firebase storage logic.
    
    
    IMPORTANT: Outside the function definition, give a list named 'data' which contains data needed to be passed to the generate_graph function.
    IMPORTANT: PLEASE GIVE DETAILED INSIGHTS IN LIST, The sentences should be short in list but the length of list should be at least 3 or 4.
    Example:

    data = [{{'loan_type': 'Auto', 'percentage': 40.0}},
        {{'loan_type': 'Home', 'percentage': 40.0}},
        {{'loan_type': 'Personal', 'percentage': 20.0}}]

    

    DO NOT LEAVE PLACEHOLDER OR ANY CODE RELATED TO save_image_to_firebase function; it has been imported and implemented by me.
    
    **Code Example Snippet:**

    import matplotlib.pyplot as plt

    from io import BytesIO

    def generate_graph(data, graph_number):
        # Example graph generation logic
        fig, ax = plt.subplots()
        ax.plot(data['x'], data['y'])

        # Create filename based on the graph number
        filename = f"graph_{{graph_number}}.png"

        image_buffer = BytesIO()
        plt.savefig(image_buffer, format='png')
        image_buffer.seek(0)

        save_image_to_firebase(image_buffer, filename)
        return image_buffer

    YOU SHOULD RETURN JSON ONLY

    DONT RETURN CODE SEPARATELY

    I Want JSON response only as output
    """
