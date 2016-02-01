#!/bin/bash
dest=docker@docker-tp4-ss2.northeurope.cloudapp.azure.com
scp ca.pem $dest:/ProgramData/docker/certs.d/ca.pem
scp server-cert.pem $dest:/ProgramData/docker/certs.d/server-cert.pem
scp server-key.pem $dest:/ProgramData/docker/certs.d/server-key.pem
ssh $dest powershell -command Restart-Service docker
