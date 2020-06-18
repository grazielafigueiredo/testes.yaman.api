
# Build da imagem
docker build -t lottocap-qa-docker .

# Executar todos os testes
docker run -it lottocap-qa-docker bash -c 'rspec spec/test/* -fd'

# Executar tests individuais
docker run -it --env-file=.env lottocap-qa-docker rspec spec/test/spec_tituloMatriz.rb -fd

# listagem da imagem
docker images | grep lottocap-qa-docker


docker run -it ruby-test2 bash -c 'rspec spec/test/* -fd' --env-file=.env

docker run -it \
    -e URI_HOMOLOG=https://api-qa2.lottocap.com.br/api \
    -e URIPROD="https://api.lottocap.com.br/api" \
    -e DATABASE_USERNAME='Lottocap' \
    -e DATABASE_PASSWORD='L0ttocap19!12@' \
    -e DATABASE_HOST='hmllottocap.database.windows.net' \
    -e DATABASE_PORT=1433 \
    -e DATABASE_DATABASE='hmllottocaptests' \
    -e DATABASE_AZURE=true \
    -e DATABASE_TIMEOUT=5000 \
    -e ID_SERIE_MAX_PRE_VENDA=230 \
    -e ID_SERIE_MAX_REGULAR=229 \
    -e ID_SERIE_JA_18=88 \
    -e ID_SERIE_JA_17=89 \
    -e ID_PRODUTO_MAX=1 \
    -e VALIDADE_ANO_CARTAO="27" \
   lottocap-qa-docker \
   rspec spec/test/spec_login.rb -fd


