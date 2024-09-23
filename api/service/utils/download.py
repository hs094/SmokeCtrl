from transformers import AutoModelForCausalLM, AutoTokenizer

# Define model name
model_name = "mtgv/MobileLLaMA-1.4B-Chat"

# Download model and tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

# Save model and tokenizer locally
model.save_pretrained("./MobileLLaMA-1.4B-Chat")
tokenizer.save_pretrained("./MobileLLaMA-1.4B-Chat")

print("Model and tokenizer downloaded and saved locally.")
