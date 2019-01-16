# https://hub.docker.com/r/library/busybox/tags/
# busybox:1.30.0-uclibc   756 KB
# busybox:1.30.0-musl     809 KB
# busybox:1.30.0-glibc    2 MB

FROM busybox:1.30.0-uclibc
ADD  IntelliJIDEALicenseServer_linux_amd64 /

EXPOSE 1017/tcp
ENTRYPOINT ["/IntelliJIDEALicenseServer_linux_amd64"]
