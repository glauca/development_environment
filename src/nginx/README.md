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
--with-http_image_filter_module
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

### Nginx 通用配置

~~~nginx
user nginx nginx;
worker_processes 4;

pid logs/nginx.pid;

events {
    use epoll;
    worker_connections 65535;
}

http {
    ##
    # Basic Settings
    ##

    include mime.types;
    default_type application/octet-stream;
    charset utf-8;

    sendfile on;
    tcp_nodelay on;
    tcp_nopush on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    ##
    # http_header设置
    ##

    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;

    server_names_hash_bucket_size 128;

    ##
    # Logging Settings
    ##

    log_format compression '$remote_addr - $remote_user [$time_local] '
                           '"$request" $status $bytes_sent '
                           '"$http_referer" "$http_user_agent" "$gzip_ratio"';

    access_log /var/log/nginx/$host-access.log compression buffer=32k flush=1d;
    error_log /var/log/nginx/$host-error.log; # debug, info, notice, warn, error, crit, alert, or emerg

    error_page 404             /404.html;
    error_page 500 502 503 504 /50x.html;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";

    gzip_vary on;
    gzip_proxied any;
    gzip_buffers 16 8k;
    gzip_comp_level 6;
    gzip_http_version 1.0;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Static resource
    ##

    location = /empty.gif {
        empty_gif;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
        expires 30d;
    }

    location ~ .*\.(js|css)?$ {
        expires 1h;
    }

    ##
    # SSL Settings
    ##

    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    #ssl_prefer_server_ciphers on;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/sites-available/*;

    ##
    # 防盗链
    # ngx_http_referer_module
    # ngx_http_secure_link_module
    ##

    valid_referers none blocked server_names
                   *.example.com example.* www.example.org/galleries/
                   ~\.google\.;

    if ($invalid_referer = 0) {
        return 403;
    }

    ##
    # 限制连接
    # ngx_http_limit_conn_module
    # ngx_http_limit_req_module
    ##
}
~~~

### Server 配置

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

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;

    location ~ \.php$ {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type, Token, App-Key, App-Secret, Sign-Time';

        if ($request_method = 'OPTIONS') {
            return 204;
        }

        fastcgi_connect_timeout 15s;
        fastcgi_pass            127.0.0.1:9000;
        #fastcgi_pass           unix:/var/run/php5-fpm.sock;
        fastcgi_index           index.php;

        fastcgi_buffer_size       64k;
        fastcgi_buffers           4 64k;
        fastcgi_busy_buffers_size 128k;

        fastcgi_intercept_errors on;
        #fastcgi_keep_conn       on;

        fastcgi_temp_file_write_size 128k;

        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param QUERY_STRING    $query_string;
        include                       fastcgi_params;
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