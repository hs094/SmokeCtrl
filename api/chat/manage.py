import warnings
warnings.filterwarnings("ignore")

import argparse
import logging
import asyncio

# LlamaCpp for model loading
from langchain_community.llms import LlamaCpp

# Prompt templating
from langchain.prompts import PromptTemplate

# Callback management and streaming
from langchain_core.callbacks import CallbackManager, StreamingStdOutCallbackHandler

# Chain setup
from langchain.chains import LLMChain
from langchain_chroma import Chroma  # Import updated Chroma for retrieval
# from langchain_huggingface import HuggingFaceEmbeddings
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class LLModel:
    """
    A class to interact with the LlamaCpp model and perform RAG queries.
    """
    
    def __init__(self, model_path: str, db_path: str):
        """
        Initializes the LLModel with a model path and Chroma database path.
        """
        self.model_path = model_path
        
        # Initialize HuggingFace embeddings
        # self.embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-mpnet-base-v2")
        
        # Initialize Chroma DB from existing embeddings and specify the embedding function
        # self.vector_store = Chroma(persist_directory=db_path, embedding_function=self.embeddings)
        
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
        # results = self.vector_store.similarity_search(query=question,k=1)
        # Invoke the chain with the question
        response = self.llama_chain.invoke({
                    "system": system,
                    "context": "",
                    # "context": "\n\n".join(result.page_content for result in results), 
                    "question": question
                })
        return response


if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description="Interact with LlamaCpp model.")
    
    # Add arguments
    parser.add_argument("--prompt", type=str, required=True, help="The prompt to generate a response for.")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose output")

    # Parse the arguments
    args = parser.parse_args()
    
    model_path = './model/llama-3.2-1b-instruct-q4_k_m.gguf'
    db_path = './datasets/embeddings'  # Path to the directory containing the existing Chroma database
    
    # Initialize the model
    model = LLModel(model_path, db_path)

    system_prompt = "Please respond to the following question in no more than 250 words. \
                    You are a helpful AI that responds in markdown format."

    # Run the async method and get the response
    response = asyncio.run(model.run(system=system_prompt, question=args.prompt))
    
    # Print the response
    if args.verbose:
        print("Verbose Output:")
        print(response)