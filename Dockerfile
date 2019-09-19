############################
# STEP 1 build executable binary
############################
FROM golang as build-env


WORKDIR $GOPATH/src/testrest
COPY . .

# Fetch dependencies.
RUN go get -d -v

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/main .

############################
# STEP 2 build a small image
############################
FROM debian:stretch-slim

# Import from build-env.
COPY --from=build-env /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env /data/storage /data/storage

ENV LANG='C.UTF-8' LC_ALL='C.UTF-8' TZ='Asia/Shanghai'

# Copy our static executable
COPY --from=build-env /go/bin/main /go/bin/main


# Run the hello binary.
ENTRYPOINT ["/go/bin/main", "--configmodel=1"]#