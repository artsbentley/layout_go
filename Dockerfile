FROM golang:1.21-bookworm as builder

RUN apt-get update && apt-get install -y --no-install-recommends \
	openssl \
	curl \
	build-essential \
	librdkafka-dev \
	libpq-dev

# Set the working directory inside the container
WORKDIR /app

COPY dsh-entrypoint ./

# Create dsh group and user
ARG tenantuserid
ENV USERID $tenantuserid
RUN addgroup --gid ${USERID} dsh && adduser --uid ${USERID} --gid ${USERID} --disabled-password --gecos "" dsh

# add goose migration binary
# ADD https://github.com/pressly/goose/releases/download/v3.7.0/goose_linux_x86_64 /bin/goose
# RUN chmod +x /bin/goose

# Copy go.mod and go.sum separately to improve cacheability
COPY go.mod go.sum ./

# Download dependencies separately to take advantage of Docker cache
RUN go mod download

# Copy source code
COPY . .

# Set ownership and permissions
RUN chown -R $USERID:$USERID . && \
	chmod +x /app/entrypoint.sh

USER dsh

# EXPOSE 8080

# Build the Go application
RUN  GOOS=linux go build -o myapp main.go

# Command to run the application
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["./myapp"]
