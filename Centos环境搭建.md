#Centos搭建nginx+rtmp环境

如果没有安装nginx，请google一下`nginx`编译安装

如果是服务器已经安装了nginx，并在提供服务，这时候要把新的模块添加进去。

###1. 获取模块

`git clone https://github.com/arut/nginx-rtmp-module.git`

###2. 查询原来编译的时候都带了哪些参数

`nginx -V`

###3. 复制原来的参数，并在后面添加上`--add-module=/root/nginx-rtmp-module` 重新编译
`./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_stub_status_module --with-http_spdy_module --with-http_ssl_module --with-ipv6 --with-http_gzip_static_module --with-http_realip_module --with-http_flv_module --with-ld-opt=\'-ljemalloc\' --add-module=/root/nginx-rtmp-module`

###4.编译,不要 make install,否则会覆盖已有
`make`

###5. 进nginx所在目录，备份原有nginx，并覆盖
`cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.bak`

`cp /root/nginx-1.8.0/objs/nginx /usr/local/nginx/sbin/nginx`

###6. 修改配置，增加rtmp配置
<pre><code>
rtmp {
    server {
        listen 1935;
        #直播流配置
        application rtmplive {
            live on;
            #为 rtmp 引擎设置最大连接数。默认为 off
            max_connections 1024;
        }
        application hls{
            live on;
            hls on;
            hls_path /usr/local/var/www/hls;
            hls_fragment 1s;
        }
    }
}
</pre></code>

###7. 重启服务器
`nginx -s reload`

