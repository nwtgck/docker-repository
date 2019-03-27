# docker-repository
Automated-Build Docker Repository for Security

## Purpose
**Guarantee that Docker images are built definitely in cloud**.

Even if someone enable Docker automation-build, the owners can push Docker Hub from their local machine. So, someone bad guy can push malicious images.

This repository guarantees the images are completely built in Travis CI, and the image tar files are published to GitHub Releases.
For proof of integrity, SHA256 of tar files are calculated.

You can **verify SHA256 in Travis CI output and downloaded files**. This ensures that your files should be built on Travis CI, and the build formula, Dockerfile and build script, "build.bash" are public without malicious code on GitHub.

## How to get Docker image

Here is an example to load Docker image.

```bash
# Download
wget https://github.com/nwtgck/docker-repository/releases/....../myimage.tar
# Load
docker load < myimage.tar
```

Then, `docker images` should output loaded image.  
You can calculate SHA256 by `shasum -a myimage.tar`.

## Structure

Here is the project structure.  
* Each repository must be under `./repos` directory.
* Each repository must have `build.bash`.
* The `build.bash` must create `./dist` directory.
* The `./dist` should have files of Docker image tar files.

```txt
repos/
├── hogeuser1
│   └── mydockerimage1
│   │  └── build.bash
│   └── mydockerimage2
│       └── build.bash
│       └── myasset1.txt
├── hogeuser2
│   └── mydockerimage1
│       └── build.bash
└── ...
```

## How to trigger Docker build

Special commit message triggers Docker build.  
For example, commit message, `"#[nwtgck/piping-server] Bump up to 0.9.2"` triggers `bash repos/nwtgck/piping-server/build.bash`.  
After build in Travis CI, the image will be available in GitHub Releases like [nwtgck/piping-server/616e72cde44824f9b0dc24501bc26f70f8266ce8](https://github.com/nwtgck/docker-repository/releases/tag/nwtgck%2Fpiping-server%2F616e72cde44824f9b0dc24501bc26f70f8266ce8).
