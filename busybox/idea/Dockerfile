# https://hub.docker.com/r/library/busybox/tags/
# busybox:1.27.2-uclibc   715 KB
# busybox:1.27.2-musl     760 KB
# busybox:1.27.2-glibc    2 MB

FROM busybox:1.27.2-uclibc
ADD  IntelliJIDEALicenseServer_linux_amd64 /

EXPOSE 1017/tcp
ENTRYPOINT ["/IntelliJIDEALicenseServer_linux_amd64"]
