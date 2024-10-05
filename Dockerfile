# Use the latest Ubuntu image
FROM ubuntu:latest
# Install required dependencies
ARG name=firstone
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    libicu-dev \
    libssl-dev \
    libkrb5-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /actions-runner

# Download the GitHub Actions runner
RUN curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.319.1.tar.gz

# Set environment variable to allow running as root
ENV RUNNER_ALLOW_RUNASROOT="1"

# Install dependencies for the GitHub runner
RUN ./bin/installdependencies.sh

# Configure the runner with unattended mode
RUN ./config.sh --url https://github.com/asif741852014/multirunners --token BLKP4O3YWCFCHNMCCKKDY4LHAE2JK --unattended --replace --name ${name}

# Make sure the runner has execute permissions
RUN chmod +x ./run.sh

# Set the entrypoint to run the GitHub Actions runner
ENTRYPOINT ["./run.sh"]