FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Update & install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl wget python3 python3-pip sudo openssh-client ca-certificates && \
    apt-get clean

# 2. Install sshx
RUN curl -sSf https://sshx.io/get | sh -s run

# 3. Create simple Hello World Python web server
WORKDIR /app
RUN echo 'from http.server import SimpleHTTPRequestHandler, HTTPServer\n\
PORT = 8080\n\
Handler = SimpleHTTPRequestHandler\n\
with HTTPServer(("", PORT), Handler) as httpd:\n\
    print(f"Serving at port {PORT}")\n\
    httpd.serve_forever()' > server.py

# 4. Expose port 8080 (Render uses this)
EXPOSE 8080

# 5. Start sshx in background and web server in foreground
CMD bash -c "\
# Start sshx and capture link \
SSHX_LINK=\$(sshx | grep 'https://sshx.io') && echo '🔗 SSHx Link: ' \$SSHX_LINK & \
# Start Hello World server \
python3 server.py \
"
