from django.shortcuts import render

# Create your views here.
from django.http import JsonResponse
from django.views import View
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.views.decorators.http import require_POST
import llama_cpp

# # Initialize the LLaMA model
# model = llama_cpp.Llama(
#     model_path="llama-3.2-1b-instruct-q4_k_m.gguf",
#     chat_format="llama-2",
# )


@method_decorator(csrf_exempt, name='dispatch')
class ChatCompletionView(View):
    def post(self, request):
        # Get the user message from the request
        user_message = request.POST.get("message")

        # Ensure message is provided
        if not user_message:
            return JsonResponse({"error": "Message content is required"}, status=400)

        # # Generate the chat completion using LLaMA
        # response = model.create_chat_completion(
        #     messages=[{"role": "user", "content": user_message}]
        # )
        return JsonResponse({"response": "Hello"})
        # Return the model's response as JSON
        return JsonResponse({"response": response['choices'][0]['message']['content']})
