# https://hub.docker.com/r/library/busybox/tags/
# busybox:1.29.3-uclibc   728 KB
# busybox:1.29.3-musl     779 KB
# busybox:1.29.3-glibc    2 MB

FROM busybox:1.29.3-uclibc
ADD  IntelliJIDEALicenseServer_linux_amd64 /

EXPOSE 1017/tcp
ENTRYPOINT ["/IntelliJIDEALicenseServer_linux_amd64"]
