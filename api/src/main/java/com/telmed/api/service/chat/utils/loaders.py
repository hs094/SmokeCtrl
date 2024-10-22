
import os
from langchain.document_loaders import (
    CSVLoader,
    UnstructuredHTMLLoader,
    BSHTMLLoader,
    UnstructuredMarkdownLoader,
    PyPDFLoader,
    WikipediaLoader
)
from langchain_community.document_loaders import AsyncChromiumLoader

def loader(file_path):
    ext = os.path.splitext(file_path)[1].lower()
    if ext == ".csv":
        # CSV file
        loader = CSVLoader(file_path=file_path)
    elif ext == ".htm" or ext == ".html":
        # HTML file (you can choose either UnstructuredHTMLLoader or BSHTMLLoader)
        loader = BSHTMLLoader(file_path)
    elif ext == ".md":
        # Markdown file
        loader = UnstructuredMarkdownLoader(file_path=file_path)
    elif ext == ".pdf":
        # PDF file
        loader = PyPDFLoader(file_path)
    else:
        raise ValueError("Unsupported file type")
    # Load data
    data = loader.load()
    return data