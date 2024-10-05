from app.models.llm import LLM
import os
import json
import requests
from dotenv import load_dotenv
load_dotenv()
from app.models.data.prompts import PromptProvider

class WorqhatLLM(LLM):
    
    def __generateDescriptionPrompt(self,context_json):
        context_string = json.dumps(context_json, indent=2)
        prompt = self.promptProvider.generateDescriptionPromptText(context_string)
        return prompt

    def __generateQueryPrompt(self,query, context_json):
        context_string = json.dumps(context_json, indent=2)
        prompt = self.promptProvider.generateQueryPromptText(query, context_string)
        return prompt
    
    def __generateOptimizedQueryPrompt(self,query, context_json):
        context_string = json.dumps(context_json, indent=2)
        prompt = self.promptProvider.generateOptimizedQueryPromptText(query, context_string)
        return prompt
    
    def __appendToHistory(self,role:str, res:str):
        self.history.append({"role": role, "content": res})

    def __send_message_to_worqhat(self, prompt):
        WORQHAT_URL = 'https://api.worqhat.com/api/ai/content/v3'
        API_KEY = os.getenv('WORQHAT_API_KEY')

        headers = {
            'Authorization': f'Bearer {API_KEY}',
            'Content-Type': 'application/json',
        }

        data = {
            "question": prompt
        }

        try:
            response = requests.post(WORQHAT_URL, headers=headers, json=data)
            response.raise_for_status()  # Raise an error for bad status codes
        except requests.exceptions.RequestException as e:
            print(f"Error while calling Worqhat API: {e}")
            return None

        # Process the JSON response
        if response.status_code == 200:
            try:
                response_json = response.json()
                if self.preserve_history:
                    self.__appendToHistory("user", prompt)
                    self.__appendToHistory("assistant", json.dumps(response_json["content"], indent=0))
                return response_json["content"]
            except (json.JSONDecodeError, KeyError) as e:
                print(f"Error decoding JSON or accessing content: {e}")
                return None
        else:
            print(f"Worqhat API returned an error: {response.status_code}, {response.text}")
            return None

    def __init__(self, preserve_history: bool):
        self.preserve_history = preserve_history
        self.promptProvider = PromptProvider()
        self.history = []

    def load_model(self):
        pass 

    def set_context(self, context):
        response_text = self.__send_message_to_worqhat(self.__generateDescriptionPrompt(context))
        return response_text

    def generate_query(self, prompt: str, context_json) -> dict:
        response_text = self.__send_message_to_worqhat(self.__generateQueryPrompt(prompt, context_json))
        return response_text

    def optimize_query(self, query: str, context_json) -> dict:
        response_text = self.__send_message_to_worqhat(self.__generateOptimizedQueryPrompt(query, context_json))
        return response_text

    def run_query(self, prompt, context):
        descriptive_json_context = self.set_context(context=context)
        query = self.generate_query(prompt, descriptive_json_context)
        optimized_query = self.optimize_query(query, descriptive_json_context).replace("```json"," ").replace("```"," ")
        data = json.loads(optimized_query)
        result_queries = [query['optimized_output'].replace("\n", " ") for query in data['queries']]
        # result_query = data["optimized_output"].replace("\\n", " ")
        return result_queries



