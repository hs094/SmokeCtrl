import warnings
warnings.filterwarnings("ignore")
import argparse
import logging
import asyncio
# LlamaCpp for model loading
from langchain_community.llms import LlamaCpp
# Prompt template
from langchain.prompts import PromptTemplate
# Callback management and streaming
from langchain_core.callbacks import CallbackManager, StreamingStdOutCallbackHandler
# Chain setup
from langchain.chains import LLMChain
from langchain_chroma import Chroma  # Import updated Chroma for retrieval
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

class LLModel:
    """
    A class to interact with the LlamaCpp model and perform RAG queries.
    """
    def __init__(self, model_path: str, db_path: str, model_name: str = "sentence-transformers/all-mpnet-base-v2"):
        """
        Initializes the LLModel with a model path and Chroma database path.
        """
        self.model_path = model_path
        # Configure logging
        logging.basicConfig(level=logging.INFO)
        logger = logging.getLogger(__name__)
        # Initialize HuggingFace embeddings
        self.embeddings = HuggingFaceEmbeddings(model_name=model_name)
        # Initialize Chroma DB from existing embeddings and specify the embedding function
        self.vector_store = Chroma(persist_directory=db_path, embedding_function=self.embeddings)
        callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])
        
        n_gpu_layers = 1
        n_batch = 512
        self.llm = LlamaCpp(
            model_path=self.model_path,
            n_gpu_layers=n_gpu_layers,
            n_batch=n_batch,
            f16_kv=True,
            n_ctx=2048,            
            temperature=0.75,
            callback_manager=callback_manager,
            verbose=False
        )
        self.create_prompt()
        self.llama_chain = self.prompt_template | self.llm
    
    def create_prompt(self) -> None:
        self.prompt_template = PromptTemplate(
            input_variables=["system", "context", "question"],
            template="""
                <|begin_of_text|>
                    <|start_header_id|>system<|end_header_id|>
                        {system}<|eot_id|>
                    <|start_header_id|>user<|end_header_id|>
                        {question}<|eot_id|>
                    <|start_header_id|>assistant<|end_header_id|>
                <|end_of_text|>
                """
        )
         # <|start_header_id|>context<|end_header_id|>
         #     {context}<|eot_id|>

    async def run(self, system: str, question: str) -> str:
        """
        Executes the model with the specified question and returns the generated response.
        """
        results = self.vector_store.similarity_search(query=question,k=3)
        # Invoke the chain with the question
        response = self.llama_chain.invoke({
                    "system": system,
                    "context": "",
                    # "context": "\n\n".join(result.page_content for result in results), 
                    "question": question
                })
        return response