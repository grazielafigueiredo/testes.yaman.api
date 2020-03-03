
# Build da imagem
docker build -t lottocap-qa-docker .

# Executar todos os testes
docker run -it lottocap-qa-docker bash -c 'rspec spec/* -fd'

# Executar tests individuais
docker run -it lottocap-qa-docker rspec spec/spec_tituloMatriz.rb -fd

# listagem da imagem
docker images | grep lottocap-qa-docker