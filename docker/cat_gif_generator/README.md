# Cat GIF Generator

A simple Flask-based web service that fetches and displays random cat GIFs using [The Cat API](https://thecatapi.com/).

## Features
- Exposes an API endpoint to fetch a random cat GIF.
- Includes a health check endpoint.
- Runs as a Docker container.

## Prerequisites
- Docker
- API Key from [The Cat API](https://thecatapi.com/) (set as an environment variable `API_KEY`)

## Getting Started

### 1. Clone the Repository
```sh
 git clone <repository-url>
 cd <repository-folder>
```

### 2. Build the Docker Image
```sh
docker build -t cat-gif-generator .
```

### 3. Run the Container
```sh
docker run -d -p 8000:8000 -e API_KEY=<your-api-key> cat-gif-generator
```
Replace `<your-api-key>` with your actual API key.

### 4. Access the Endpoints
- **Health Check:** http://localhost:8000/health
- **Generate Cat GIF:** http://localhost:8000/generate-cat-gif

## API Endpoints
### 1. Health Check
**GET** `/health`
- Returns `{"status": "healthy"}` if the service is running.

### 2. Generate Random Cat GIF
**GET** `/generate-cat-gif`
- Fetches a random cat GIF from The Cat API and displays it in an HTML page.
- Returns an error message if fetching fails.

## Environment Variables
| Variable | Description |
|----------|-------------|
| `API_KEY` | API key for The Cat API (required) |

## Dockerfile Overview
- Uses `python:3.9-slim` as the base image.
- Installs necessary dependencies (`boto3`, `pillow`, `requests`, `flask`).
- Copies the `cat_gif_generator.py` script into the container.
- Exposes port `8000` for the Flask application.
- Runs the Flask application when the container starts.

---
Enjoy your cat GIFs! 😺

