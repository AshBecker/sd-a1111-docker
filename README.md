# filepath: /stable-diffusion-docker/stable-diffusion-docker/README.md
# Stable Diffusion Docker Setup

This project provides a Dockerized setup for running Stable Diffusion. It includes all necessary dependencies and configurations to get started quickly.

## Project Structure

```
stable-diffusion-docker
├── docker
│   ├── Dockerfile
│   └── entrypoint.sh
├── config
│   └── stable-diffusion.service
├── README.md
```

## Dockerfile

The `Dockerfile` contains instructions to build the Docker image for running Stable Diffusion. It sets up the base image, installs dependencies, and copies necessary files.

### Build the Docker Image

To build the Docker image, navigate to the `docker` directory and run:

```bash
docker build -t stable-diffusion-image .
```

## Running the Docker Container

After building the image, you can run the container using the following command:

```bash
docker run --gpus all -d --name stable-diffusion -p 7860:7860 stable-diffusion-image
```

## Setting Up a Private Docker Registry

To set up a private Docker registry, follow these steps:

1. **Install Docker Registry**: Run a Docker registry container.
   ```bash
   docker run -d -p 5000:5000 --restart always --name registry registry:2
   ```

2. **Tag Your Image**: After building your Docker image, tag it for your private registry.
   ```bash
   docker tag stable-diffusion-image localhost:5000/stable-diffusion-image
   ```

3. **Push the Image**: Push the tagged image to your private registry.
   ```bash
   docker push localhost:5000/stable-diffusion-image
   ```

4. **Configure Docker Daemon**: If you're using a self-signed certificate, configure the Docker daemon to allow insecure registries by editing `/etc/docker/daemon.json`:
   ```json
   {
     "insecure-registries" : ["localhost:5000"]
   }
   ```
   Restart Docker:
   ```bash
   sudo systemctl restart docker
   ```

## Entry Point Script

The `entrypoint.sh` script is executed when the Docker container starts. It sets up the environment and starts the Stable Diffusion service.

## Conclusion

This setup allows you to easily deploy and run Stable Diffusion in a Docker container, leveraging GPU resources dynamically. Make sure to follow the instructions carefully to ensure a smooth setup.