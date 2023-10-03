# belex-docker

This repo/project is a stop-gap for general access to GSI Technology's Copperhead belex compiler and will be obsolete when the compiler goes FOSS.

Likely you just want to pull and run pre-built Docker containers (see next section.)

There are also instructions here to build the containers.

## Running Docker containers

Instructions will depend on the release, listed in this section in reverse chronological order.

### gsicompiler/belex:develop-1696297364

Prerequisites:
* Docker
* AWS CLI utilities

AWS CLI setup:
* Acquire AWS keys from GSI Technology (associativecomputing@gsitechnology.com or gwilliams@gsitechnology.com).
* Run "aws configure" and configure your keys. For other settings, choose the defaults.

Docker setup:
* Authenticate to our Docker ECR:
```aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 182642843343.dkr.ecr.us-east-1.amazonaws.com```
* Pull the Docker container:
```docker pull 182642843343.dkr.ecr.us-east-1.amazonaws.com/gsicompiler/belex:develop-1696297364```

Run the Docker container:
* Launch the container:
```docker run -it -d 182642843343.dkr.ecr.us-east-1.amazonaws.com/gsicompiler/belex:develop-1696297364 bash```
* Get the running container's Docker id:
```docker ps```
* Launch a shell into the running Docker container:
```docker exec -it <docker_id> /bin/bash```
* Activate the pre-configured conda environment:
```conda activate belex-test_emulation```
* Run a pytest function:
```pytest -s tests/test_belex_hdc_library.py::test_hdc_hamming```

Run the debugger with a breakpoint:
* Insert the line "import pudb; pudb.set_trace();" at the top of the function "test_hdc_hamming" in the file "test_belex_hdc_library.py".
* Run this pytest function again and it will break in the pudb debugger:
```pytest -s tests/test_belex_hdc_library.py::test_hdc_hamming```


## Build the Docker container(s)

* You need to ask GSI Technology for access to the BitBucket belex* repositories ((associativecomputing@gsitechnology.com or gwilliams@gsitechnology.com).
* Run the build script:
```build.sh```
* By default, it packages up the latest "develop" branch.  If you need something different, change it in the build.sh script.

