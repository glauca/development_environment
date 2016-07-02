## Nginx 配置

### Installing nginx

~~~nginx
--prefix=/usr/local/nginx
--http-client-body-temp-path=/var/cache/nginx/client_temp
--http-proxy-temp-path=/var/cache/nginx/proxy_temp
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp
--http-scgi-temp-path=/var/cache/nginx/scgi_temp
--with-http_ssl_module
--with-http_realip_module
--with-http_addition_module
--with-http_sub_module
--with-http_dav_module
--with-http_flv_module
--with-http_mp4_module
--with-http_gunzip_module
--with-http_gzip_static_module
--with-http_random_index_module
--with-http_secure_link_module
--with-http_stub_status_module
--with-http_auth_request_module
--with-threads
--with-stream
--with-stream_ssl_module
--with-http_slice_module
--with-mail
--with-mail_ssl_module
--with-file-aio
--with-http_v2_module
--with-ipv6
--with-pcre-jit
~~~

### Nginx 配置

~~~nginx
user nginx nginx;
worker_processes 4;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    ##
    # Logging Settings
    ##

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";

    # gzip_vary on;
    # gzip_proxied any;
    # gzip_comp_level 6;
    # gzip_buffers 16 8k;
    # gzip_http_version 1.1;
    # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*;
}
~~~

### 普通配置

[Server names](http://nginx.org/en/docs/http/server_names.html)

~~~nginx
server {
    listen       80;
    server_name  example.org;
    return       301 http://www.example.org$request_uri;
}

server {
    listen      80 default_server;
    server_name www.example.org;
    root        /data/www;

    location / {
        index   index.html index.php;
    }

    location ~* \.(gif|jpg|png)$ {
        expires 30d;
    }

    location ~ \.php$ {
        fastcgi_pass  localhost:9000;
        fastcgi_param SCRIPT_FILENAME
                      $document_root$fastcgi_script_name;
        include       fastcgi_params;
    }
}
~~~

### [Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)

+ Load balancing methods
    + round-robin
    + least-connected
    + ip-hash

~~~nginx
http {
    upstream myapp1 {
        # Use NGINX shared memory
        zone backend 64k;

        # distributing the new requests to a less busy server
        least_conn;

        # maintain a maximum of 20 idle connections to each upstream server
        keepalive 20;

        # Apply session persistence for this upstream group
        sticky cookie srv_id expires=1h domain=.example.com path=/servlet;

        # the same client will always be directed to the same server
        ip_hash;

        server srv1.example.com weight=3;
        server srv2.example.com slow_start=30s;
        server srv3.example.com;

    }

    server {
        listen 80;

        location / {
            proxy_pass http://myapp1;

            health_check interval=2s fails=1 passes=5 uri=/test.php match=statusok;

            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header Accept-Encoding "";
            proxy_redirect http://staging.example.com/ http://$host/;

            # Rewrite the 'Host' header to the value in the client request,
            # or primary server name
            proxy_set_header Host $host;

            # Alternatively, put the value in the config:
            # proxy_set_header Host www.example.com;

            # Replace any references inline to staging.example.com
            sub_filter http://staging.example.com/ /;
            sub_filter_once off;
        }
    }

    match statusok {
        # Used for /test.php health check
        status 200;
        header Content-Type = text/html;
        body ~ "Server[0-9]+ is alive";
    }

    server {
        listen 8080;
        root /usr/share/nginx/html;

        location = /status {
            status; # Live activity monitoring
        }
    }
}
~~~

### [Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)

~~~nginx
server {
    ##
    # One megabyte of the cache contains about 4000 sessions.
    # The default cache timeout is 5 minutes.
    ##
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    listen              443 ssl;
    server_name         www.example.com;
    keepalive_timeout   70;

    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
}
~~~