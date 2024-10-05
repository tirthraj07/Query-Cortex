'''
pip install docker psycopg2 mysql-connector-python
'''
from abc import ABC,abstractmethod

class Database(ABC):
    @abstractmethod
    def __init__(self):
        '''
            Instantiate a docker container of the particular database
        '''
        pass

    @abstractmethod
    def connect(self):
        '''
            Connect to the instance of the database
        '''
        pass

    @abstractmethod
    def disconnect(self):
        '''
            Disconnect to the instance of the database
        '''
        pass

    @abstractmethod
    def run_queries(self, queries:list):
        '''
            Run all query in list of queries in the database
        '''
        pass
