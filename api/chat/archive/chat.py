from llama_cpp import Llama

model_path = "model/1B/llama-3.2-1b-instruct-q4_k_m.gguf"
# Set gpu_layers to the number of layers to offload to GPU. Set to 0 if no GPU acceleration is available on your system.
llm = Llama(
  model_path=model_path,  # Download the model file first
  n_ctx=32768,            # The max sequence length to use - note that longer sequence lengths require much more resources
  n_threads=8,            # The number of CPU threads to use, tailor to your system and the resulting performance
  n_gpu_layers=35,         # The number of layers to offload to GPU, if you have GPU acceleration available
  verbose=False
)
# Simple inference example
output = llm(
  "What is name of President of India?", # Prompt
  max_tokens=512,                        # Generate up to 512 tokens
  stop=["</eot_id>"],                   # Example stop token - not necessarily correct for this specific model! Please check before using.
  echo=False,                            # Whether to echo the prompt
)

# Extracting and printing the text from the output
if 'choices' in output and len(output['choices']) > 0:
    response_text = output['choices'][0]['text']
    print(response_text)
else:
    print("No valid output received.")

