# DockerKubeArch
build a docker and kubernetes compatible architecture.
## Installation
bash install.sh  
source $HOME/.bashrc
## Usage
dkBuilder [-w workspace] [-a author] [-v version] [--config config file] [project name]
## Directory structure
project_name/  
|-- images/  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- build.sh  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- Dockerfile  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- prod_env/  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- build.sh  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- Dockerfile  
|-- kubernetes/  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- builder.yaml  
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- run.yaml
## Note
for the source code, you should build a directory named 'source' as the root of the source code
