PIPING_SERVER_VERSION=v0.9.2
IMAGE_NAME=nwtgck/piping-server:$PIPING_SERVER_VERSION

# Make ./dist directory
mkdir dist
# Clone repository
git clone https://github.com/nwtgck/piping-server.git
# Go to the repository
cd piping-server
# Checkout the version
git checkout $PIPING_SERVER_VERSION
# Build Docker image
docker build -t $IMAGE_NAME .
# Go back
cd ..
# Save image tar into ./dist
docker save $IMAGE_NAME > dist/nwtgck-piping-server-$PIPING_SERVER_VERSION.tar
