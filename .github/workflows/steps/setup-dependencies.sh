name: Setup Dependencies

description: Install necessary dependencies

runs:
  using: "composite"
  steps:
    - name: Install System Dependencies
      run: |
        sudo apt-get update
        sudo apt-get remove -y containerd.io docker.io || true
        sudo apt-get install -y golang jq curl pre-commit
      shell: bash

    - name: Install Docker CE
      run: |
        curl -fsSL https://get.docker.com | sudo sh
        sudo usermod -aG docker $USER
        newgrp docker
        docker --version
      shell: bash
