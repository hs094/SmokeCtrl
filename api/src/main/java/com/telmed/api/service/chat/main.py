import asyncio
import os
import argparse
import numpy as np  # Import numpy for NaN
from utils.model import LLModel
from utils.embeddings import create_embeddings

def str_to_bool(value):
    """Convert string to boolean."""
    if value.lower() in ('true', '1', 'yes'):
        return True
    elif value.lower() in ('false', '0', 'no'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description="Interact with LlamaCpp model.")
    # # Add arguments
    parser.add_argument("--prompt", type=str, required=True, help="The prompt to generate a response for.")
    parser.add_argument("--model", type=str, required=True, help="Add Path for the Model to be Run")
    parser.add_argument("--embed", type=str, required=True, help="Add Path for Embedding Model")
    parser.add_argument("-e", action="store_true", help="If true, instructs the code to re-create the embeddings.")
    parser.add_argument("-v", action="store_true", help="Enable verbose output")

    # Path to directory containing documents to process
    document_directory = os.path.join(os.path.dirname(__file__), 'datasets', 'documents')
    # Define the path to persist embeddings
    embeddings_path = os.path.join(os.path.dirname(__file__), 'datasets', 'embeddings')
    # Parse the arguments
    args = parser.parse_args()
    if args.v:
        print(f"Prompt: {args.prompt}")
        print(f"Model Path: {args.model}")
        print(f"Embedding Re-Creation: {args.embed}")
        print(f"Document Directory: {document_directory}")
        print(f"Embeddings Path: {embeddings_path}")

    if args.e is not None and args.e and args.embed:
        print("* Creating Embeddings......")
        create_embeddings(document_directory, embeddings_path, hf_embed_model=args.embed)  # Pass the necessary arguments to create_embeddings
        print("@ Done!")

    model = LLModel(args.model, embeddings_path, model_name=args.embed)

    system_def = "Please respond to the following question in no more than 250 words. \
                  You are a helpful AI that responds in markdown format."
    # Run the async method and get the response
    response = asyncio.run(model.run(system=system_def, question=args.prompt))

    # Print the response at the end
    print(response)

    

