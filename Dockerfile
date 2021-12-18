version: '1'

services:
  nginx-proxy:
    image: jwilder/nginx-proxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - certs:/etc/nginx/certs:ro
      - vhostd:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
    labels:
      - com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    restart: always
    environment:
      - NGINX_PROXY_CONTAINER=nginx-proxy
    volumes:
      - certs:/etc/nginx/certs:rw
      - vhostd:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
      - /var/run/docker.sock:/var/run/docker.sock:ro

  www:
    image: nginx
    restart: always
    expose:
      - "80"
    volumes:
      - /Users/kbs/git/peladonerd/varios/1/www:/usr/share/nginx/html:ro
    environment:
      - VIRTUAL_HOST=pablokbs.com,www.pablokbs.com
      - LETSENCRYPT_HOST=pablokbs.com,www.pablokbs.com
      - LETSENCRYPT_EMAIL=pablo@pablokbs.com
    depends_on:
      - nginx-proxy
      - letsencrypt
volumes: 
  certs:
  html:
  vhostd:
