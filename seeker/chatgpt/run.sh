VERSION=0.5
docker stop chatgpt-demo
docker rm chatgpt-demo
docker run -d --name chatgpt-demo \
    -p 80:4000 \
    registry.cn-hangzhou.aliyuncs.com/yantao0527/chatgpt-demo:${VERSION}
