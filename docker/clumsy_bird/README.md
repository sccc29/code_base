# Clumsy Bird on Docker

This repository provides a Dockerized setup for running [Clumsy Bird](https://github.com/ellisonleao/clumsy-bird), a JavaScript-based Flappy Bird clone.

## Project Overview

Clumsy Bird is an open-source, HTML5-based game built with [Phaser](https://phaser.io/), a popular JavaScript game framework. This Docker setup allows you to easily run the game in a containerized environment with minimal dependencies on the host system.

## Dockerfile Breakdown

The provided `Dockerfile` sets up a containerized environment for running Clumsy Bird:

- Uses the **Node.js 18 Alpine** base image for a lightweight setup.
- Sets up the working directory at `/src/clumsy-bird`.
- Installs `git` for cloning the Clumsy Bird repository.
- Clones the official Clumsy Bird repository from GitHub.
- Ensures proper file permissions and ownership for security.
- Runs the container as a non-root user (`node`) to enhance security.
- Installs project dependencies and development tools, including `grunt-cli` for task automation.
- Exposes port **8001**, where the game will be served.
- Uses `npx grunt connect` to start the game server.

## Prerequisites

Ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)

## How to Build and Run

1. Clone this repository or create a `Dockerfile` with the contents provided.
2. Build the Docker image:
   ```sh
   docker build -t clumsy-bird .
   ```
3. Run the container:
   ```sh
   docker run -p 8001:8001 clumsy-bird
   ```
4. Access the game in your web browser at:
   ```
   http://localhost:8001
   ```

## Customization

If you want to modify Clumsy Bird, you can:
1. Fork the repository and make changes.
2. Modify the `Dockerfile` to use your fork instead:
   ```dockerfile
   RUN git clone https://github.com/YOUR_GITHUB_USERNAME/clumsy-bird.git /src/clumsy-bird
   ```
3. Rebuild and run the container.

## Troubleshooting

- **Port conflicts:** Ensure port 8001 is not in use by another process.
- **Permission issues:** Ensure Docker has the necessary permissions on your system.
- **Dependency errors:** Try running `docker run -it clumsy-bird sh` to inspect dependencies inside the container.

## License

Clumsy Bird is released under the **MIT License**. See the [original repository](https://github.com/ellisonleao/clumsy-bird) for details.

