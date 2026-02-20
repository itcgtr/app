#!/bin/sh

# Start MinIO in the background
minio server /data --console-address :9001 &
MINIO_PID=$!

# Wait for MinIO to be ready
echo "Waiting for MinIO to start..."
sleep 10

# Set up MinIO alias with credentials
echo "Setting up MinIO alias..."
mc alias set local http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

# List buckets
echo "Listing existing buckets..."
mc ls local

# Create a bucket
echo "Creating bucket 'public'..."
mc mb local/public || echo "Bucket 'public' already exists"

# Setup bucket policy to make it public
echo "Setting bucket policy to public..."
mc anonymous set public local/public

# Keep MinIO running
echo "MinIO is ready. Keeping container running..."
wait $MINIO_PID






# echo "This is a script to interact with MinIO using the mc client."

# echo $MINIO_ROOT_USER

# echo $MINIO_ROOT_PASSWORD


# login to minio
# mc alias set local http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

# list buckets
# mc ls local

# create a bucket
# mc mb local/public

# setup a bucket policy
# mc anonymous set public local/public



# delete a bucket
# mc rb local/public