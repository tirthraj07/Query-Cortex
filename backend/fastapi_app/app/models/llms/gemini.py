from app.models.llm import LLM
import os
import json
import google.generativeai as genai
from dotenv import load_dotenv
import re
from app.models.data.prompts import PromptProvider
load_dotenv()

class GeminiLLM(LLM):

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
    
    def __generateVisualizationPrompt(self, results):
        prompt = self.promptProvider.generateVisualizationPromptText(results)
        return prompt
    
    def __appendToHistory(self,role:str, res:str):
        self.history.append({"role": role, "content": res})

    def __send_message_to_model(self,prompt):
        response = self.chat_session.send_message(prompt)
        if self.preserve_history:
            self.__appendToHistory("user", prompt)
            self.__appendToHistory("assistant", json.dumps(response.text, indent=0))
        return response.text
    
    def send_prompt_to_model(self, prompt):
        response = self.chat_session.send_message(prompt)
        return response.text

    def __init__(self, preserve_history:bool):
        self.GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
        self.GEMINI_MODEL_NAME = os.getenv('GEMINI_MODEL_NAME')
        genai.configure(api_key=self.GEMINI_API_KEY)
        
        self.generation_config = {
            "temperature": 1,
            "top_p": 0.95,
            "top_k": 64,
            "max_output_tokens": 8192,
            "response_mime_type": "text/plain",
        }
        
        if(preserve_history):
            self.preserve_history = True
        else:
            self.preserve_history = False
        self.history = []

        self.promptProvider = PromptProvider()

    def load_model(self):
        self.safe = [
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_NONE",
        },
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_NONE",
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_NONE",
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_NONE",
        },
    ]

        self.model = genai.GenerativeModel(
            model_name=self.GEMINI_MODEL_NAME,
            generation_config=self.generation_config,
            safety_settings=self.safe
        )
        self.chat_session = self.model.start_chat(
            history=self.history
        )
    
    def set_context(self, context):
        response_text = self.__send_message_to_model(self.__generateDescriptionPrompt(context))
        response_text = re.search(r'```json([\s\S]*?)```', response_text).group(1).strip()
        return response_text

    def generate_query(self, prompt: str, context_json) -> dict:
        response_text = self.__send_message_to_model(self.__generateQueryPrompt(prompt, context_json))
        print("PROMPT GENERATED: ")
        response_text = re.search(r'```json([\s\S]*?)```', response_text).group(1).strip()
        print(response_text)
        return response_text

    def optimize_query(self, query: str, context_json) -> dict:
        response_text = self.__send_message_to_model(self.__generateOptimizedQueryPrompt(query, context_json))
        print("OPTIMIZED PROMPT: ")
        response_text = re.search(r'```json([\s\S]*?)```', response_text).group(1).strip()
        print(response_text)
        return response_text
    
    def visualize_data(self, results):
        response_text = self.send_prompt_to_model(self.__generateVisualizationPrompt(results))
        print(response_text)
        response_text = response_text.replace("```json", "").replace("```", "").replace("python", "").strip()
        response_text = response_text.replace("\n", "").replace("\r", "")
        try:
            data = json.loads(response_text)
        except json.JSONDecodeError as e:
            print(f"JSONDecodeError: {e.msg} at line {e.lineno} column {e.colno} (char {e.pos})")
            data = {"response": []}

        return data


    def run_query(self, prompt, context):
        print("\n\n\nRUN QUERY FUNCTION")

        descriptive_json_context = self.set_context(context=context)
        query = self.generate_query(prompt, descriptive_json_context)

        print("\n\n\nQUERY ", query)
        optimized_query = self.optimize_query(query, descriptive_json_context).replace("```json"," ").replace("```"," ")
        print("\n\nOPTIMISED ", optimized_query)
        data = json.loads(optimized_query)

        print(data)
        
        result_queries = [query['optimized_output'].replace("\n", " ") for query in data['queries']]
        print(result_queries)
        # result_query = data["optimized_output"].replace("\\n", " ")
        return result_queries
