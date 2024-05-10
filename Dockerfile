FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y git curl zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
        --output /tmp/vscode-cli.tar.gz && \
    tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin && \
    rm /tmp/vscode-cli.tar.gz

ENV TUNNEL_NAME=my-default-tunnel

CMD code tunnel --accept-server-license-terms --name $TUNNEL_NAME