FROM ubuntu as main

RUN apt update && apt install -y vim wget curl openssh-client gpg git coreutils jq

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 

RUN wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli jammy main" | tee /etc/apt/sources.list.d/azure-cli.list

RUN apt update && apt -y install terraform azure-cli

COPY checkdns.sh /root

CMD ["/bin/bash"]
