
docker run -d \

    -p PORT:PORT \

    -v PATH_TO_CONF:/data \

    --name="joal" \

    anthonyraymond/joal \

    --joal-conf="/data" \

    --spring.main.web-environment=true \



    --joal.ui.path.prefix="HELLOQWER" \

    --joal.ui.secret-token="hi"
DOCKER_IMAGE_NAME="anthonyraymond/joal"
ARCHITECTURES="amd64 arm arm64"

# Login into docker
docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"


platforms=""
for arch in $ARCHITECTURES
do
# Build for all architectures and push manifest
  platforms="linux/$arch,$platforms"
done

platforms=${platforms::-1}


# Push multi-arch image
buildctl build --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --exporter image \
      --exporter-opt name=docker.io/$DOCKER_IMAGE_NAME:$TRAVIS_TAG \
      --exporter-opt push=true \
      --frontend-opt platform=$platforms \
      --frontend-opt filename=./Dockerfile


# Push image for every arch with arch prefix in tag
for arch in $ARCHITECTURES
do
# Build for all architectures and push manifest
  buildctl build --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --exporter image \
      --exporter-opt name=docker.io/$DOCKER_IMAGE_NAME:$TRAVIS_TAG-$arch \
      --exporter-opt push=true \
      --frontend-opt platform=linux/$arch \
      --frontend-opt filename=./Dockerfile &
done

wait

docker pull $DOCKER_IMAGE_NAME:$TRAVIS_TAG
docker tag $DOCKER_IMAGE_NAME:$TRAVIS_TAG $DOCKER_IMAGE_NAME:latest
docker push $DOCKER_IMAGE_NAME:latest
