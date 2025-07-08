#
docker build -t vm-panel .
# docker build -t vm-panel .

#
docker run --privileged -p 8080:8080 -d vm-panel

