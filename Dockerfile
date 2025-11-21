FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Update & install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl wget python3 python3-pip sudo openssh-client ca-certificates && \
    apt-get clean

# 2. Install & run SSHx (background)
RUN curl -sSf https://sshx.io/get | sh -s install

# 3. Simple Python web server
WORKDIR /app
RUN echo 'from http.server import SimpleHTTPRequestHandler, HTTPServer\n\
PORT = 8080\n\
Handler = SimpleHTTPRequestHandler\n\
with HTTPServer(("", PORT), Handler) as httpd:\n\
    print(f"Serving at port {PORT}")\n\
    httpd.serve_forever()' > server.py

# 4. Expose port 8080
EXPOSE 8080

# 5. Start SSHx and web server
CMD bash -c "\
# Run SSHx in background \
curl -sSf https://sshx.io/get | sh -s run & \
# Start web server \
python3 server.py \
"
