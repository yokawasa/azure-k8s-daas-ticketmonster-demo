FROM karm/mod_cluster-master-dockerhub
MAINTAINER Yoichi Kawasaki <yoichi.kawasaki@microsoft.com>

##
## Overwriting oringinal karm/mod_cluster-master-dockerhub to make customization such as
## - update httpd.conf (CustomLog change)
## - symlinking access_log->/dev/stdout and error_log->/dev/stderr
##

ENV HTTPD_MC_BUILD_DIR  /opt/httpd-build

COPY httpd.conf ${HTTPD_MC_BUILD_DIR}/conf/

RUN ln -sf /dev/stdout ${HTTPD_MC_BUILD_DIR}/logs/access_log \	
    && ln -sf /dev/stderr ${HTTPD_MC_BUILD_DIR}/logs/error_log


ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start", "-DFOREGROUND"]
