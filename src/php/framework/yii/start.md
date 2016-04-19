## Getting Started

### Installing Yii

#### Installing via Composer

~~~bash
composer global require "fxp/composer-asset-plugin:~1.1.1"

composer create-project --prefer-dist yiisoft/yii2-app-basic basic
composer create-project --prefer-dist yiisoft/yii2-app-advanced yii-application
~~~

~~~nginx
server {
    charset utf-8;
    client_max_body_size 128M;

    listen 80; ## listen for ipv4
    #listen [::]:80 default_server ipv6only=on; ## listen for ipv6

    server_name mysite.local;
    root        /path/to/basic/web;
    index       index.php;

    access_log  /path/to/basic/log/access.log;
    error_log   /path/to/basic/log/error.log;

    location / {
        # Redirect everything that isn't a real file to index.php
        try_files $uri $uri/ /index.php?$args;
    }

    # uncomment to avoid processing of calls to non-existing static files by Yii
    #location ~ \.(js|css|png|jpg|gif|swf|ico|pdf|mov|fla|zip|rar)$ {
    #    try_files $uri =404;
    #}
    #error_page 404 /404.html;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
        fastcgi_pass   127.0.0.1:9000;
        #fastcgi_pass unix:/var/run/php5-fpm.sock;
        try_files $uri =404;
    }

    location ~ /\.(ht|svn|git) {
        deny all;
    }
}
~~~

When using this configuration, you should also set `cgi.fix_pathinfo=0` in the php.ini file in order to avoid many unnecessary system stat() calls.

Also note that when running an HTTPS server, you need to add `fastcgi_param HTTPS on`; so that Yii can properly detect if a connection is secure.