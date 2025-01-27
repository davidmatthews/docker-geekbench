# Use Ubuntu as the base image
FROM ubuntu:latest

ARG TARGETPLATFORM

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Download and install Geekbench
WORKDIR /opt
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then \
        download_url="https://cdn.geekbench.com/Geekbench-6.3.0-Linux.tar.gz" ; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
        download_url="https://cdn.geekbench.com/Geekbench-6.3.0-LinuxARMPreview.tar.gz" ; \
    else \
        echo "Unsupported platform" ; \
    fi \
    && wget "$download_url" -O geekbench.tar.gz --no-check-certificate \
    && tar -xzf geekbench.tar.gz \
    && rm geekbench.tar.gz

# Set the Geekbench binary directory in PATH
ENV PATH="/opt/Geekbench-6.3.0-Linux:$PATH"

# Define the entrypoint to run the Geekbench benchmark
ENTRYPOINT ["/opt/Geekbench-6.3.0-Linux/geekbench6"]