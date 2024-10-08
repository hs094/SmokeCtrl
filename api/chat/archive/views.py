import warnings
import logging

warnings.filterwarnings("ignore")

# Import necessary libraries from LangChain
from langchain_community.llms import LlamaCpp
from langchain_core.callbacks import CallbackManager, StreamingStdOutCallbackHandler
from langchain.prompts import PromptTemplate

# Import Django REST framework components
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration for LLaMA model
n_gpu_layers = 1  # Number of layers to run on GPU
n_batch = 128  # Batch size, adjust based on memory constraints

# Initialize the callback manager for streaming
callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

# Path to your LLaMA model
llama_model_path = "/Users/hardiksoni/Library/CloudStorage/OneDrive-iitkgp.ac.in/Dev.hs/Github-Stage/MTP/iMediXcare/chat/service/model/1B/llama-3.2-1b-instruct-q4_k_m.gguf"

# Initialize LlamaCpp model
llama_llm = LlamaCpp(
    model_path=llama_model_path,
    n_gpu_layers=n_gpu_layers,
    max_tokens=2000,
    temperature=0.1,
    n_batch=n_batch,
    f16_kv=True,  # Ensure correct memory usage
    callback_manager=callback_manager,
    verbose=True,  # Verbose logging
)

# Define the prompt template for the model
prompt_template = PromptTemplate(
    input_variables=["input_text"],
    template="A chat between a curious user and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the user's questions. USER: Respond to the following input in no more than 450 words: {input_text} ASSISTANT:"
    # template="Respond to the following input in no more than 200 words: {input_text}"
)

# Define the LLM chain using the prompt template and the LLaMA model
llama_chain = prompt_template | llama_llm

# Create a class-based view for generating responses
@method_decorator(csrf_exempt, name='dispatch')
class GenerateResponseView(APIView):
    """
    A view to generate responses from the LLaMA model based on input text.
    """

    def post(self, request):
        """
        Handle POST requests to generate a response.

        Parameters:
        request (Request): The incoming request containing the input text.

        Returns:
        Response: A JSON response containing the model's generated response or an error message.
        """
        logger.info("Incoming request: %s", request.data)
        try:
            # Extract input_text from request data
            input_text = request.data.get('input_text')
            if not input_text:
                return Response({"error": "input_text is required"}, status=status.HTTP_400_BAD_REQUEST)

            # Generate response using the LLaMA model
            response = llama_chain.invoke({"input_text": input_text})
            return Response({"response": response}, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error("Error generating response: %s", str(e))
            # Handle exceptions and return an error response
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
