from transformers import AutoTokenizer, AutoModel

# Define model name
model_name = 'sentence-transformers/all-mpnet-base-v2'

# Load model from HuggingFace Hub
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModel.from_pretrained(model_name)

# Save model and tokenizer locally
model.save_pretrained("./all-mpnet-base-v2")
tokenizer.save_pretrained("./all-mpnet-base-v2")

print("Model and tokenizer downloaded and saved locally.")
