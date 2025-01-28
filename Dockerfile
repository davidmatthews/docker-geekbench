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
        echo '#!/bin/bash\n/opt/Geekbench-6.3.0-Linux/geekbench6' > /entrypoint.sh; \
        export PATH="/opt/Geekbench-6.3.0-Linux:$PATH"; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
        download_url="https://cdn.geekbench.com/Geekbench-6.3.0-LinuxARMPreview.tar.gz" ; \
        echo '#!/bin/bash\n/opt/Geekbench-6.3.0-LinuxARMPreview/geekbench6' > /entrypoint.sh; \
        export PATH="/opt/Geekbench-6.3.0-LinuxLinuxARMPreview:$PATH"; \
    else \
        echo "Unsupported platform" ; \
    fi \
    && wget "$download_url" -O geekbench.tar.gz --no-check-certificate \
    && tar -xzf geekbench.tar.gz \
    && rm geekbench.tar.gz \
    && chmod +x /entrypoint.sh

# Set the Geekbench binary directory in PATH
ENV PATH="$PATH"

# Define the entrypoint to run the Geekbench benchmark
ENTRYPOINT ["/entrypoint.sh"]