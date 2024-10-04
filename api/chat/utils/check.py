import os
import time
import warnings
from langchain import hub
import nest_asyncio
from typing import List
from langchain import hub

from langchain_community.document_loaders import (
    CSVLoader, BSHTMLLoader, UnstructuredMarkdownLoader, PyPDFLoader
)
from langchain_chroma import Chroma
from langchain_community.embeddings.huggingface import HuggingFaceEmbeddings
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter

# Suppress warnings for clean output
warnings.filterwarnings("ignore")
nest_asyncio.apply()

def load_documents_from_directory(directory_path):
    """
    Load and process all supported documents from a specified directory.
    
    Args:
        directory_path (str): Path to the directory containing documents.

    Returns:
        List[Document]: A list of loaded and processed documents.
    """
    documents = []
    
    # Iterate over all files in the directory
    for filename in os.listdir(directory_path):
        file_path = os.path.join(directory_path, filename)
        
        # Load the document based on file type
        try:
            docs = loader(file_path)
            documents.extend(docs)
        except ValueError as e:
            print(f"Skipping unsupported file: {filename}. Error: {e}")
    
    return documents

def loader(file_path):
    """
    Load a document based on its file extension.
    
    Args:
        file_path (str): Path to the file to load.

    Returns:
        List[Document]: A list of loaded documents.
    """
    ext = os.path.splitext(file_path)[1].lower()
    
    # Determine loader based on file extension
    if ext == ".csv":
        loader = CSVLoader(file_path=file_path)
    elif ext in [".htm", ".html"]:
        loader = BSHTMLLoader(file_path)
    elif ext == ".md":
        loader = UnstructuredMarkdownLoader(file_path=file_path)
    elif ext == ".pdf":
        loader = PyPDFLoader(file_path)
    else:
        raise ValueError(f"Unsupported file type: {ext}")
    
    # Load the data
    data = loader.load()
    return data

def build_vector_store(directory_path, model_name="sentence-transformers/all-mpnet-base-v2", persist_directory=None):
    """
    Build a Chroma vector store based on documents in a directory, using HuggingFace embeddings.
    
    Args:
        directory_path (str): Path to the directory containing the documents.
        model_name (str): Name of the HuggingFace model to use for embeddings.
        persist_directory (str, optional): Path to persist the embeddings.

    Returns:
        Chroma: A Chroma vector store instance based on the processed documents.
    """
    # Load documents from the directory
    hf_embeddings = HuggingFaceEmbeddings(model_name=model_name)
    print(f"Loading documents from: {directory_path}")
    docs = load_documents_from_directory(directory_path)
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
    splits = text_splitter.split_documents(docs)
    vectorstore = Chroma(persist_directory=persist_directory).from_documents(documents=splits, embedding=hf_embeddings)
    return vectorstore

# Example usage
if __name__ == "__main__":
    start_time = time.time()
    # Path to directory containing documents to process
    document_directory = os.path.join(os.path.dirname(__file__), '..', 'datasets', 'documents')
    
    # Define the path to persist embeddings
    embeddings_path = os.path.join(os.path.dirname(__file__), '..', 'datasets', 'embeddings')
    
    # Build the vector store based on documents in the directory
    # vector_store = build_vector_store(document_directory, persist_directory=embeddings_path)
    vector_store = Chroma(
        persist_directory=embeddings_path,
        embedding_function=HuggingFaceEmbeddings(model_name="sentence-transformers/all-mpnet-base-v2")
    )
    # Retrieve and print a sample result based on a query
    query = "What is Clinical Institute Withdrawal Assessment of Alcohol Scale, Revised (CIWA-Ar)"
    results = vector_store.similarity_search(query=query,k=5)
    # for res in results:
    #     print(f"* {res.page_content} [{res.metadata}]")

    for i, result in enumerate(results, 1):
        file_name = result.metadata.get('source', 'Unknown')
        print(f"Result {i}:")
        print(f"File: {file_name}")
        print(result.page_content)
        print("\n" + "="*50 + "\n")
    
    end_time = time.time()
    # Print the time taken for the search
    print(f"Time taken for similarity search: {end_time - start_time:.4f} seconds")
