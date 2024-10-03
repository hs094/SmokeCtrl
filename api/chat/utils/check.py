import os
import warnings
import nest_asyncio
from typing import List
from langchain_community.document_loaders import (
    CSVLoader, BSHTMLLoader, UnstructuredMarkdownLoader, PyPDFLoader
)
from langchain.schema import Document
from langchain_community.embeddings.huggingface import HuggingFaceEmbeddings
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_community.document_transformers import Html2TextTransformer

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

def build_retriever(directory_path, model_name="sentence-transformers/all-mpnet-base-v2", persist_directory=None):
    """
    Build a retriever based on documents in a directory, using HuggingFace embeddings and Chroma.
    
    Args:
        directory_path (str): Path to the directory containing the documents.
        model_name (str): Name of the HuggingFace model to use for embeddings.
        persist_directory (str, optional): Path to persist the embeddings.

    Returns:
        VectorStoreRetriever: A retriever instance based on the processed documents.
    """
    # Load documents from the directory
    print(f"Loading documents from: {directory_path}")
    documents = load_documents_from_directory(directory_path)
    
    # Convert HTML documents to plain text if needed
    html2text = Html2TextTransformer()
    docs_transformed = html2text.transform_documents(documents)
    
    # Split text into chunks for efficient embedding processing
    text_splitter = CharacterTextSplitter(chunk_size=128, chunk_overlap=0)
    chunked_documents = text_splitter.split_documents(docs_transformed)
    
    # Initialize HuggingFace embeddings
    embeddings = HuggingFaceEmbeddings(model_name=model_name)
    
    # Initialize Chroma vector store
    db = Chroma.from_documents(chunked_documents, embeddings, persist_directory=persist_directory)
    
    # Persist the database if a directory is provided
    if persist_directory:
        db.persist()
    
    # Create retriever
    retriever = db.as_retriever()
    return retriever

# Example usage
if __name__ == "__main__":
    # Path to directory containing documents to process
    document_directory = os.path.join(os.path.dirname(__file__), '..', 'datasets', 'documents')
    
    # Define the path to persist embeddings
    embeddings_path = os.path.join(os.path.dirname(__file__), '..', 'datasets', 'embeddings')
    
    # Build retriever based on documents in the directory
    retriever = build_retriever(document_directory, persist_directory=embeddings_path)
    
    # Retrieve and print a sample result based on a query
    query = "What is Clinical Institute Withdrawal Assessment of Alcohol Scale, Revised (CIWA-Ar)"
    results = retriever.get_relevant_documents(query)
    
    for i, result in enumerate(results, 1):
        file_name = result.metadata.get('source', 'Unknown')
        print(f"Result {i}:")
        print(f"File: {file_name}")
        print(result.page_content)
        print("\n" + "="*50 + "\n")
