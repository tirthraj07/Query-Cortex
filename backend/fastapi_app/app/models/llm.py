from abc import ABC, abstractmethod

class LLM(ABC):
    @abstractmethod
    def load_model(self):
        """
        Load the AI model. This could involve loading a pre-trained model from a file or API.
        """
        pass

    @abstractmethod
    def generate_query(self, prompt: str) -> dict:
        """
        Generate SQL or any other text/code based on the given prompt and context.
        
        :param prompt: The user's query or natural language question.
        :return: A dictionary containing the generated query or response.
        """
        pass

    @abstractmethod
    def optimize_query(self, query: str) -> dict:
        """
        Optimize the generated query without altering its results.
        
        :param query: The SQL or text query to be optimized.
        :return: A dictionary containing the optimized query.
        """
        pass

    @abstractmethod
    def set_context(self, context: dict):
        """
        Set any additional context needed for query generation.
        
        :param context: A dictionary of metadata or any required context information.
        """
        
    @abstractmethod
    def run_query(self, prompt, context):
        """
        Call all functions and return the query
        
        """
