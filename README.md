# Build da imagem
docker build -t yaman-api .

# Executar todos os testes
docker run -it yaman-api bash -c 'cucumber'
