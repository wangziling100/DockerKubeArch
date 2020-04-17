#!/bin/sh

# generate a docker and kubernetes compatible project framework
# usage: dkBuilder [-w workspace] [-a author] [-v version] [--config config file] [project name]

usage(){
    echo "Usage:"
    echo "dkBuilder [-w workspace] [-a author] [-v version] [--config config file] [project name]"
    exit -1
}
# init variable
ws=`pwd`
author=''
version=''
config=''
args="`getopt -u -q -o "a:hv:w:" -l "author,config,version,help" -- "$@ "`"
[ $? -ne 0 ] && usage

set -- ${args}

while [ -n "$1" ]; do
    case "$1" in
        -a|--author) author=$2
            shift;;

        -v) version=$2
            shift;;

        --config) 
            config=$2
            shift;;

        # set workspace
        -w) ws=$2
            shift;;

        -h|--help)
            usage
            shift;;

        --) shift
            break;;

        *)  usage

    esac
    shift
done
cd `dirname $0`
if [ -z $config ]; then
    config='default.conf'
fi
# set variables
while read line; do
    str=${line#*author: }
    if [ "$str" != "$line" ] && [ -z "$author" ]; then
        author=$str
    fi
    str=${line#*version: }
    if [ "$str" != "$line" ] && [ -z "$version" ]; then
        version=$str
    fi
done < $config

# set project name
for param in "$@";do
    proj_name=$param
done

cd $ws
mkdir $proj_name
cd $proj_name
mkdir -p images/prod_env && mkdir kubernetes && touch images/Dockerfile && touch images/prod_env/Dockerfile
cat >> images/build.sh<<EOF
#!/usr/bin/sh

AUTHOR=$author
PROJ_NAME=$proj_name
BUILD_LATEST_TAG="latest"
BUILD_CURRENT_TAG=$version

docker build -t \$AUTHOR/\$PROJ_NAME:\${BUILD_LATEST_TAG} -t \$AUTHOR/\$PROJ_NAME:\${BUILD_CURRENT_TAG} \`dirname \$0\`
EOF

cat >> images/prod_env/build.sh<<EOF
#!/usr/bin/sh

AUTHOR=$author
PROJ_NAME=$proj_name
BUILD_LATEST_TAG="latest"
BUILD_CURRENT_TAG=$version

docker build -t \$AUTHOR/\${PROJ_NAME}_prod:\${BUILD_LATEST_TAG} -t \$AUTHOR/\${PROJ_NAME}_prod:\${BUILD_CURRENT_TAG} \`dirname \$0\`
EOF

cat >> kubernetes/builder.yaml<<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: builder
  namespace: your_namespace
spec:
  template:
    spec:
      containers:
      - name: builder
        image: $author/${proj_name}_prod
        imagePullPolicy: IfNotPresent
        # command: ['your_command']
        volumeMounts:
        - mountPath: /workspace
          name: source

    volumes:
    - name: source
      hostPath:
        path: `pwd $ws`/source
        type: Directory
    restartPolicy: Never
EOF

cat >> kubernetes/run.yaml<<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: run
  namespace: your_namespace
spec:
  template:
    spec:
      containers:
      - name: run
        image: $author/${proj_name}
        imagePullPolicy: IfNotPresent
        # command: ['your_command']
        volumeMounts:
        - mountPath: /workspace
          name: source

    volumes:
    - name: source
      hostPath:
        path: `pwd $ws`/$proj_name/source
        type: Directory
    restartPolicy: Never
EOF

cat >> update_ws.sh<<EOF
#!/bin/sh
# update the current directory of the workspace, if you clone the project, you may change the workspace directory

ws=\`dirname \$0\`
cd \$ws
ws=\`pwd\`
bn=\`basename \$ws\`
sed -i "s?path:.*\$bn/source?path: \$ws/source?" kubernetes/builder.yaml
sed -i "s?path:.*\$bn/source?path: \$ws/source?" kubernetes/run.yaml
EOF
