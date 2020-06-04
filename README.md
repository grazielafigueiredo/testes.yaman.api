
# Build da imagem
docker build -t lottocap-qa-docker .

# Executar todos os testes
docker run -it lottocap-qa-docker bash -c 'rspec spec/test/* -fd'

# Executar tests individuais
docker run -it lottocap-qa-docker rspec spec/test/spec_tituloMatriz.rb -fd

# listagem da imagem
docker images | grep lottocap-qa-docker


docker run -it ruby-test2 bash -c 'rspec spec/test/* -fd' --env-file=.env
