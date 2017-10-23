## horkel/php
FROM horkel/archlinux:2017.11.22
MAINTAINER AlphaTr <alphatr@alphatr.com>

COPY build.sh /build.sh
RUN /build.sh

EXPOSE 9000

CMD ["php-entrypoint"]
