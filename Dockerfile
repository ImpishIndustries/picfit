FROM ubuntu:14.04
MAINTAINER James Andrews (jandrews@impishindustries.com)

RUN apt-get update
RUN apt-get -y upgrade 
RUN apt-get -y install curl \
    git \
    make

# Set environment variables
ENV PATH "$PATH:/usr/local/go/bin"
ENV GOPATH "/usr/local/go/bin"
    
# Download and install Go lang support
RUN curl -O https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -xvf go1.8.linux-amd64.tar.gz
RUN mv go /usr/local

# Change into the go src directory
WORKDIR /usr/local/go/src

# Clone PicFit Dependencies
RUN mkdir -p github.com/codegangsta
WORKDIR /usr/local/go/src/github.com/codegangsta
RUN git clone https://github.com/codegangsta/cli.git

# Clone PicFit
RUN mkdir -p github.com/thoas
WORKDIR /usr/local/go/src/github.com/thoas
RUN git clone https://github.com/thoas/picfit.git

# Build PicFit
WORKDIR /usr/local/go/src/github.com/thoas/picfit
RUN make build

COPY config.json /tmp/config.json

CMD /usr/local/go/src/github.com/thoas/picfit/bin/picfit -c /tmp/config.json
