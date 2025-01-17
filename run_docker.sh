#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
CHECK_MARK='\xE2\x9C\x94'
CROSS_MARK='\xE2\x9D\x8C'

function print_error() {
    printf "${RED}${CROSS_MARK} $1${NC}\n"
}

function print_success() {
    printf "${GREEN}${CHECK_MARK} $1${NC}\n"
}

function cleanup_and_exit() {
    docker stop infratools
    docker rm infratools
    exit 1
}

if ! systemctl is-active --quiet docker; then
    print_error "Error: Docker service is not running. Please start Docker and try again."
    exit 1
fi

if docker ps -a --format '{{.Names}}' | grep -q "^infratools$"; then
    docker stop infratools
    docker rm infratools
    print_success "Old container 'infratools' has been stopped and removed."
fi

docker build -t infratools .
if [[ $? -ne 0 ]]; then
    print_error "Error building Docker image. Check the logs above."
    exit 1
fi

docker run -d --name infratools -p 5000:5000 infratools
if [[ $? -ne 0 ]]; then
    print_error "Error starting the container. Check the logs above."
    exit 1
fi

print_success "Waiting for the container to initialize..."
sleep 10

print_success "Checking if port 5000 is accessible..."
if ! nc -z localhost 5000; then
    print_error "Error: Port 5000 is not accessible. Check the container logs."
    cleanup_and_exit
fi

print_success "Testing if the API is working..."
response=$(curl -s http://localhost:5000/test)
expected_response="API OK"

if [[ "$response" == *"$expected_response"* ]]; then
    print_success "Test successful! The 'infratools' container is running on port 5000."
else
    print_error "Test failed! Expected response not received. Actual response: '$response'"
    cleanup_and_exit
fi
