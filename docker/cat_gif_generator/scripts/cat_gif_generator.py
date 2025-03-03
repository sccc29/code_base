from flask import Flask, jsonify
import requests
from io import BytesIO
from PIL import Image, ImageSequence
import os

app = Flask(__name__)

API_KEY = os.getenv("API_KEY")  # Ensure API_KEY is set
CAT_API_URL = "https://api.thecatapi.com/v1/images/search?mime_types=gif"

@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy"}), 200

@app.route("/generate-cat-gif", methods=["GET"])
def generate_cat_gif():
    headers = {
        "Content-Type": "application/json",
        "x-api-key": API_KEY
    }
    try:
        # Fetch a random cat GIF from an API
        response = requests.get(CAT_API_URL, headers=headers, timeout=5)
        if response.status_code != 200:
            return "<h1>Error: Failed to fetch cat GIF</h1>", 500
        
        cat_data = response.json()
        cat_gif_url = cat_data[0].get("url")
        if not cat_gif_url:
            return "<h1>Error: No GIF URL found</h1>", 500
        
        # Download the GIF
        gif_response = requests.get(cat_gif_url, timeout=5)
        gif_bytes = BytesIO(gif_response.content)
        
        # Process the GIF (optional: resize, add watermark, etc.)
        gif = Image.open(gif_bytes)
        output_bytes = BytesIO()
        frames = [frame.copy() for frame in ImageSequence.Iterator(gif)]
        frames[0].save(output_bytes, format="GIF", save_all=True, append_images=frames[1:])
        output_bytes.seek(0)
        
        # Return an HTML response that directly embeds the GIF
        return f"""
            <html>
                <head><title>Cat GIF Generator</title></head>
                <body>
                    <h1>Random Cat GIF</h1>
                    <img src="{cat_gif_url}" alt="Cat GIF"/>
                </body>
            </html>
        """
    
    except requests.exceptions.RequestException as e:
        return f"<h1>Error: Request error - {str(e)}</h1>", 500
    except Exception as e:
        return f"<h1>Error: Internal error - {str(e)}</h1>", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)