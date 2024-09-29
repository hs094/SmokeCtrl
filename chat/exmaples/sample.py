from langchain.llms import LlamaCpp
from langchain.prompts import PromptTemplate
from langchain.runnables import RunnableSequence
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt

# Initialize the LangChain LlamaCpp model
model_path = "path/to/your/llama-model.bin"
llama_llm = LlamaCpp(model_path=model_path)

# Create a prompt template
prompt_template = PromptTemplate(
    input_variables=["input_text"],
    template="Respond to the following input: {input_text}"
)

# Create a runnable sequence
llama_chain = RunnableSequence(prompt_template | llama_llm)

@api_view(['POST'])
@method_decorator(csrf_exempt, name='dispatch')
def generate_response(request):
    try:
        input_text = request.data.get('input_text')
        if not input_text:
            return Response({"error": "input_text is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        response = llama_chain.invoke({"input_text": input_text})
        return Response({"response": response}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
