# Use official Python runtime as a parent image
FROM python:3.9-slim

# Install Miniconda
RUN apt-get update && apt-get install -y wget bzip2 \
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && /opt/conda/bin/conda clean -tipsy

# Update PATH to include Conda
ENV PATH=/opt/conda/bin:$PATH

# Set the working directory in the container
WORKDIR /chat

# Copy the current directory contents into the container at /chat
COPY . /chat

# Install necessary build tools and dependencies
RUN apt-get install -y build-essential cmake gcc g++ git libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# Create Conda environment from the environment.yml file
COPY environment.yml /chat/environment.yml
RUN conda env create -f /chat/environment.yml

# Activate the Conda environment
ENV CONDA_DEFAULT_ENV=bot
ENV PATH="/opt/conda/envs/bot/bin:$PATH"

# Make sure the Conda environment is activated in the shell
SHELL ["conda", "run", "-n", "bot", "/bin/bash", "-c"]

# Install llama-cpp-python and langchain using Conda or Pip inside the Conda environment
RUN pip uninstall llama-cpp-python -y \
    && pip install -U llama-cpp-python --no-cache-dir \
    && pip install -U langchain langchain-community

# Expose port 8000 to the outside world
EXPOSE 8000

# Run the Django development server
CMD ["conda", "run", "--no-capture-output", "-n", "bot", "python", "service/manage.py", "runserver", "0.0.0.0:8000"]
