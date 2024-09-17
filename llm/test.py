import os
from llama_index.llms.openai import OpenAI

os.environ["OPENAI_API_KEY"] = "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"
resp = OpenAI().complete("Paul Graham is ")
print(resp)