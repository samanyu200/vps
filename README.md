#
docker build -t vm-panel .
#
docker run --privileged -p 9090:9090 -d vm-panel

