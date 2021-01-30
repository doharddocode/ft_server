docker build . --tag ft_server
docker run --rm -it -p 80:80 -p 443:443 ft_server