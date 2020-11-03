
docker run -d \

    -p PORT:PORT \

    -v PATH_TO_CONF:/data \

    --name="joal" \

    anthonyraymond/joal \

    --joal-conf="/data" \

    --spring.main.web-environment=true \

    --server.port="8080" \

    --joal.ui.path.prefix="HELLOQWER" \

    --joal.ui.secret-token="hi"
