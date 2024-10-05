
from app.models.llms.gemini import GeminiLLM
from app.models.llms.worqhat import WorqhatLLM
from app.services.metadata_service import generate_metadata
from app.config import queries, connection_uri


def load_model(model):
    if model == "worqhat":
        return WorqhatLLM(preserve_history=True)
    
    if model == "gemini":
        return GeminiLLM(preserve_history=True)
    
def generate_query(prompt, model, dbms, connection_uri):
    json_context = generate_metadata(queries, connection_uri, dbms)
    print("Meta Data generated")
    llm = load_model(model)
    llm.load_model()
    print(prompt)
    query = llm.run_query(prompt=prompt, context=json_context)
    print("Query Generated")
    print(query)

    return query