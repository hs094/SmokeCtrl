import os

# Construct the relative path
file_path = os.path.join(os.path.dirname(__file__), '..', 'datasets', 'documents', 'input.txt')

# Normalize the path (handles any extra slashes or dots)
file_path = os.path.abspath(file_path)

# Open the file
with open(file_path, 'r') as file:
    data = file.read()
    print(data)
