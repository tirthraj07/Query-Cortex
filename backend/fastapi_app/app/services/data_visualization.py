from app.services.query_service import load_model
from app.services.firebase_services.storage_service import store_to_firebasebase

def execute_code_from_string(code_string, data_list, count):
    formatted_code = code_string.strip()

    # Ensure 'url' is defined in the global scope
    globals()["url"] = ""

    if formatted_code != "":
        formatted_code += f"""
data = {data_list}
image_buffer = generate_graph(data, {count})  # Use count as an integer
url = store_to_firebasebase(image_buffer, "graph_{count}")
print(f'url_received', url)
"""
    print(f"\n\nCount: {count}\n")
    
    # Execute the code using globals()
    exec(formatted_code, globals())

    # Return the 'url' from the global scope
    return globals()["url"]

def generate_data_visualization(results, model="gemini"):
    llm = load_model(model)
    llm.load_model()
    response = llm.visualize_data(results)

    return response


