# %% [markdown] {"papermill":{"duration":0.004153,"end_time":"2025-01-18T12:42:09.708462","exception":false,"start_time":"2025-01-18T12:42:09.704309","status":"completed"},"tags":[]}
# # Llama 3.2 7B Model Finetuning

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:42:09.716185Z","iopub.status.busy":"2025-01-18T12:42:09.715899Z","iopub.status.idle":"2025-01-18T12:42:53.303250Z","shell.execute_reply":"2025-01-18T12:42:53.302359Z"},"papermill":{"duration":43.592884,"end_time":"2025-01-18T12:42:53.304891","exception":false,"start_time":"2025-01-18T12:42:09.712007","status":"completed"},"tags":[]}
!pip install -q huggingface_hub
!pip install -Uq transformers[torch] datasets
!pip install -q bitsandbytes trl peft accelerate
!pip install -q flash-attn --no-build-isolation

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:42:53.315624Z","iopub.status.busy":"2025-01-18T12:42:53.315378Z","iopub.status.idle":"2025-01-18T12:42:53.318786Z","shell.execute_reply":"2025-01-18T12:42:53.318155Z"},"papermill":{"duration":0.010011,"end_time":"2025-01-18T12:42:53.320032","exception":false,"start_time":"2025-01-18T12:42:53.310021","status":"completed"},"tags":[]}
dataset_path = '/kaggle/input/medical-intelligence-dataset-40k-disease-info-qa'
model_id = "meta-llama/Llama-3.2-3B-Instruct"
hf_token = 'hf_api_token'
wandb_token = 'wandb_api_key'

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:42:53.330718Z","iopub.status.busy":"2025-01-18T12:42:53.330451Z","iopub.status.idle":"2025-01-18T12:43:11.222557Z","shell.execute_reply":"2025-01-18T12:43:11.221708Z"},"papermill":{"duration":17.899293,"end_time":"2025-01-18T12:43:11.224106","exception":false,"start_time":"2025-01-18T12:42:53.324813","status":"completed"},"tags":[]}
import re
import warnings
import random
warnings.filterwarnings('ignore')
from datasets import Dataset, load_dataset, DatasetDict
import pandas as pd
import os
import torch
from time import time
from datasets import load_dataset
# from kaggle_secrets import UserSecretsClient
from peft import LoraConfig, PeftModel, prepare_model_for_kbit_training
from transformers import (
    AutoConfig,
    AutoModelForCausalLM,
    AutoTokenizer,
    BitsAndBytesConfig,
    AutoTokenizer,
    TrainingArguments,
)
from trl import SFTTrainer,setup_chat_format
from peft import LoraConfig
import wandb


# Specify the device
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print(device)

# user_secrets = UserSecretsClient()
HF_TOKEN = 'hugging-face-api'
wandb_key = 'wandb-api'
username = 'hs-094'
repository_name = 'llama-3.2-3b-medical-dataset-fine-tuned'
raw_datasets = load_dataset(dataset_path)

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:11.234874Z","iopub.status.busy":"2025-01-18T12:43:11.234608Z","iopub.status.idle":"2025-01-18T12:43:14.209350Z","shell.execute_reply":"2025-01-18T12:43:14.208430Z"},"papermill":{"duration":2.981894,"end_time":"2025-01-18T12:43:14.211095","exception":false,"start_time":"2025-01-18T12:43:11.229201","status":"completed"},"tags":[]}
! huggingface-cli login --token $HF_TOKEN
! wandb login $wandb_key

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:14.222440Z","iopub.status.busy":"2025-01-18T12:43:14.222200Z","iopub.status.idle":"2025-01-18T12:43:14.245525Z","shell.execute_reply":"2025-01-18T12:43:14.244906Z"},"papermill":{"duration":0.03028,"end_time":"2025-01-18T12:43:14.246779","exception":false,"start_time":"2025-01-18T12:43:14.216499","status":"completed"},"tags":[]}
test_split_ratio = 0.2

# Split the dataset
split_datasets = raw_datasets["train"].train_test_split(test_size=0.2)

# Wrap the splits into a DatasetDict
raw_datasets = DatasetDict({
    "train": split_datasets["train"],
    "test": split_datasets["test"]
})
raw_datasets

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:14.257462Z","iopub.status.busy":"2025-01-18T12:43:14.257255Z","iopub.status.idle":"2025-01-18T12:43:14.265607Z","shell.execute_reply":"2025-01-18T12:43:14.264958Z"},"papermill":{"duration":0.015036,"end_time":"2025-01-18T12:43:14.266868","exception":false,"start_time":"2025-01-18T12:43:14.251832","status":"completed"},"tags":[]}
raw_datasets["train"][:2]

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:14.277954Z","iopub.status.busy":"2025-01-18T12:43:14.277755Z","iopub.status.idle":"2025-01-18T12:43:14.282233Z","shell.execute_reply":"2025-01-18T12:43:14.281615Z"},"papermill":{"duration":0.011343,"end_time":"2025-01-18T12:43:14.283396","exception":false,"start_time":"2025-01-18T12:43:14.272053","status":"completed"},"tags":[]}
raw_datasets["test"][:2]

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:14.295060Z","iopub.status.busy":"2025-01-18T12:43:14.294860Z","iopub.status.idle":"2025-01-18T12:43:14.299281Z","shell.execute_reply":"2025-01-18T12:43:14.298688Z"},"papermill":{"duration":0.011592,"end_time":"2025-01-18T12:43:14.300480","exception":false,"start_time":"2025-01-18T12:43:14.288888","status":"completed"},"tags":[]}
compute_dtype = torch.bfloat16
bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=compute_dtype,
        bnb_4bit_use_double_quant=True)

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:43:14.311733Z","iopub.status.busy":"2025-01-18T12:43:14.311490Z","iopub.status.idle":"2025-01-18T12:45:57.659025Z","shell.execute_reply":"2025-01-18T12:45:57.658181Z"},"papermill":{"duration":163.354618,"end_time":"2025-01-18T12:45:57.660411","exception":false,"start_time":"2025-01-18T12:43:14.305793","status":"completed"},"tags":[]}
time_start = time()

# Load model configuration
model_config = AutoConfig.from_pretrained(
    model_id,
    trust_remote_code=True,
    max_new_tokens=1024
)

# Load model
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    trust_remote_code=True,
    config=model_config,
    quantization_config=bnb_config,
    device_map=None  # Disable 'auto' since we're specifying the device manually
)

# Move model to the specified device
model.to(device)

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_id)

time_end = time()
print(f"Prepare model, tokenizer: {round(time_end-time_start, 3)} sec.")

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:45:57.674536Z","iopub.status.busy":"2025-01-18T12:45:57.674288Z","iopub.status.idle":"2025-01-18T12:46:03.952341Z","shell.execute_reply":"2025-01-18T12:46:03.951500Z"},"papermill":{"duration":6.286669,"end_time":"2025-01-18T12:46:03.954124","exception":false,"start_time":"2025-01-18T12:45:57.667455","status":"completed"},"tags":[]}
tokenizer.chat_template = None
model, tokenizer = setup_chat_format(model, tokenizer)
model = prepare_model_for_kbit_training(model)

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:03.977202Z","iopub.status.busy":"2025-01-18T12:46:03.976868Z","iopub.status.idle":"2025-01-18T12:46:03.982029Z","shell.execute_reply":"2025-01-18T12:46:03.981226Z"},"papermill":{"duration":0.016377,"end_time":"2025-01-18T12:46:03.983344","exception":false,"start_time":"2025-01-18T12:46:03.966967","status":"completed"},"tags":[]}
tokenizer.eos_token_id

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:03.997490Z","iopub.status.busy":"2025-01-18T12:46:03.997188Z","iopub.status.idle":"2025-01-18T12:46:04.000834Z","shell.execute_reply":"2025-01-18T12:46:04.000092Z"},"papermill":{"duration":0.012211,"end_time":"2025-01-18T12:46:04.002128","exception":false,"start_time":"2025-01-18T12:46:03.989917","status":"completed"},"tags":[]}
terminators = [
    tokenizer.eos_token_id,
    tokenizer.convert_tokens_to_ids("<|eot_id|>")
]

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:04.016044Z","iopub.status.busy":"2025-01-18T12:46:04.015813Z","iopub.status.idle":"2025-01-18T12:46:04.020068Z","shell.execute_reply":"2025-01-18T12:46:04.019321Z"},"papermill":{"duration":0.012515,"end_time":"2025-01-18T12:46:04.021364","exception":false,"start_time":"2025-01-18T12:46:04.008849","status":"completed"},"tags":[]}
def apply_chat_template(example, tokenizer):
    inputs = example["input"]
    outputs = example["output"]
    
    # Initialize the messages list with a system message (specific to medical domain)
    messages = [{"role": "system", "content": "You are a medical assistant. Please provide accurate, evidence-based responses to the user's medical questions. If you're unsure about an answer, suggest consulting a healthcare professional."}]
    
    # Add user message
    messages.append({"role": "user", "content": inputs})
    
    # Add assistant message
    messages.append({"role": "assistant", "content": outputs})
    
    # Apply the chat template
    text = tokenizer.apply_chat_template(messages, tokenize=False)
    
    # Return a new dictionary with the modified content
    example["text"] = text
    return example

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:04.035130Z","iopub.status.busy":"2025-01-18T12:46:04.034850Z","iopub.status.idle":"2025-01-18T12:46:04.340065Z","shell.execute_reply":"2025-01-18T12:46:04.339113Z"},"papermill":{"duration":0.313578,"end_time":"2025-01-18T12:46:04.341492","exception":false,"start_time":"2025-01-18T12:46:04.027914","status":"completed"},"tags":[]}
print(len(raw_datasets['train']['input']))
print(len(raw_datasets['train']['output']))

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:04.356307Z","iopub.status.busy":"2025-01-18T12:46:04.356038Z","iopub.status.idle":"2025-01-18T12:46:04.428614Z","shell.execute_reply":"2025-01-18T12:46:04.427834Z"},"papermill":{"duration":0.081356,"end_time":"2025-01-18T12:46:04.429877","exception":false,"start_time":"2025-01-18T12:46:04.348521","status":"completed"},"tags":[]}
print(len(raw_datasets['test']['input']))
print(len(raw_datasets['test']['output']))

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:04.444398Z","iopub.status.busy":"2025-01-18T12:46:04.444160Z","iopub.status.idle":"2025-01-18T12:46:10.651378Z","shell.execute_reply":"2025-01-18T12:46:10.650685Z"},"papermill":{"duration":6.215921,"end_time":"2025-01-18T12:46:10.652775","exception":false,"start_time":"2025-01-18T12:46:04.436854","status":"completed"},"tags":[]}
# Assuming raw_datasets["train"] is a Dataset object
datasets = dict()
datasets["train"] = raw_datasets["train"].map(lambda example: apply_chat_template(example, tokenizer))
datasets["test"] = raw_datasets["test"].map(lambda example: apply_chat_template(example, tokenizer))

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:10.668405Z","iopub.status.busy":"2025-01-18T12:46:10.668174Z","iopub.status.idle":"2025-01-18T12:46:10.672709Z","shell.execute_reply":"2025-01-18T12:46:10.672057Z"},"papermill":{"duration":0.013153,"end_time":"2025-01-18T12:46:10.673855","exception":false,"start_time":"2025-01-18T12:46:10.660702","status":"completed"},"tags":[]}
datasets

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:10.689219Z","iopub.status.busy":"2025-01-18T12:46:10.689013Z","iopub.status.idle":"2025-01-18T12:46:10.692467Z","shell.execute_reply":"2025-01-18T12:46:10.691691Z"},"papermill":{"duration":0.012237,"end_time":"2025-01-18T12:46:10.693779","exception":false,"start_time":"2025-01-18T12:46:10.681542","status":"completed"},"tags":[]}
# set pad_token_id equal to the eos_token_id if not set
if tokenizer.pad_token_id is None:
  tokenizer.pad_token_id = tokenizer.eos_token_id

# Set reasonable default for models without max length
if tokenizer.model_max_length > 100_000:
  tokenizer.model_max_length = 2048

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:10.708574Z","iopub.status.busy":"2025-01-18T12:46:10.708360Z","iopub.status.idle":"2025-01-18T12:46:10.713594Z","shell.execute_reply":"2025-01-18T12:46:10.712974Z"},"papermill":{"duration":0.013857,"end_time":"2025-01-18T12:46:10.714755","exception":false,"start_time":"2025-01-18T12:46:10.700898","status":"completed"},"tags":[]}
# Assuming datasets is already defined as shown in your example
train_dataset = datasets["train"]
eval_dataset = datasets["test"]

# Sample 2 random indices from the training set
for index in random.sample(range(len(train_dataset)), 2):
    # Print the 'text' field from the processed training set
    print(f"Sample {index} of the processed training set:\n\n{train_dataset[index]['text']}")
    print("#####################################")

# %% [code] {"execution":{"iopub.execute_input":"2025-01-18T12:46:10.729579Z","iopub.status.busy":"2025-01-18T12:46:10.729352Z","iopub.status.idle":"2025-01-18T12:46:10.735784Z","shell.execute_reply":"2025-01-18T12:46:10.734785Z"},"papermill":{"duration":0.015136,"end_time":"2025-01-18T12:46:10.737005","exception":true,"start_time":"2025-01-18T12:46:10.721869","status":"failed"},"tags":[]}
# Path where the Trainer will save its checkpoints and logs
trained_model_id = "Llama-3.2-3B-Instruct-medical-dataset"
output_dir = 'working/'

# QLoRA-specific configuration for Llama 3.2 3B Instruct
peft_config = LoraConfig(
    r=4,
    lora_alpha=16,
    lora_dropout=0.1,
    bias="none",
    task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj",],
)
# Training arguments based on config
training_args = TrainingArguments(
    fp16=False,  # specify bf16=True instead when training on GPUs that support bf16 else fp16
    bf16=False,
    do_eval=True,
    optim="paged_adamw_8bit",
    evaluation_strategy="epoch",
    gradient_accumulation_steps=1,
    gradient_checkpointing=True,
    gradient_checkpointing_kwargs={"use_reentrant": False},
    learning_rate=2.0e-05,
    log_level="info",
    logging_steps=5,
    logging_strategy="steps",
    lr_scheduler_type="cosine",
    max_steps=-1,
    num_train_epochs=1,
    output_dir=output_dir,
    overwrite_output_dir=True,
    per_device_eval_batch_size=1,  # originally set to 8
    per_device_train_batch_size=1,  # originally set to 8
    push_to_hub=True,
    hub_model_id=f"{username}/{repository_name}",
    report_to="none",
    save_steps=100, 
    save_strategy="no",
    save_total_limit=2,
    seed=42,
    # QLoRA-specific arguments:
    # You might also want to specify `quantization` or related arguments depending on the implementation
)

# %% [code]
# Ensure the model and tokenizer are moved to the correct device
model.to(device)
tokenizer.to(device)
print("Model and Tokenizer Loaded on GPU.")

# %% [code] {"papermill":{"duration":null,"end_time":null,"exception":null,"start_time":null,"status":"pending"},"tags":[]}
trainer = SFTTrainer(
        model=model,
        args=training_args,
        train_dataset=train_dataset,
        eval_dataset=eval_dataset,
        dataset_text_field="text",
        tokenizer=tokenizer,
        packing=True,
        peft_config=peft_config,
        max_seq_length=tokenizer.model_max_length,
)
trainer.train()

# %% [code] {"papermill":{"duration":null,"end_time":null,"exception":null,"start_time":null,"status":"pending"},"tags":[]}
trainer.push_to_hub()
print('Finished')

# %% [code] {"papermill":{"duration":null,"end_time":null,"exception":null,"start_time":null,"status":"pending"},"tags":[]}
# Example of how to integrate quantization (assuming use of bitsandbytes or similar)
from bitsandbytes import load_quantized_model

# Load your model with quantization
model = AutoModelForCausalLM.from_pretrained(
    f"{username}/{repository_name}",
    trust_remote_code=True,
    config=model_config,
    quantization_config=bnb_config,
    device_map='auto',
)

# Continue with training using the model
print("Loaded Model")