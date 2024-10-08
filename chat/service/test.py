import requests

# The URL of your Django server's chat completion endpoint
url = 'http://127.0.0.1:8888/api/chat/'  # Ensure this is the correct URL

# The message you want to send to the LLaMA model
data = {
    'message': 'Give me a detailed plan to get rid of Tobacco Addiction in 1 year?'
}

# Send the request and stream the response
try:
    with requests.post(url, data=data, stream=True) as response:
        # Ensure the request was successful
        if response.status_code == 200:
            # Stream the response token by token
            for chunk in response.iter_content(chunk_size=1024, decode_unicode=True):
                if chunk:
                    print(chunk, end='', flush=True)  # Print each token as it's received
        else:
            print(f"Request failed with status code {response.status_code}")
except requests.exceptions.RequestException as e:
    print(f"An error occurred: {e}")
