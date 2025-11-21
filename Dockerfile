FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Update & upgrade
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl wget sudo openssh-client ca-certificates && \
    apt-get clean

# 2. Install sshx
RUN curl -fsSL https://sshx.io/install.sh | bash

# 3. Auto-restart sshx forever
CMD bash -c "while true; do \
    echo '🔌 Starting sshx...'; \
    sshx; \
    echo '❌ sshx exited. Restarting in 2 seconds...'; \
    sleep 2; \
done"
