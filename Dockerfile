#############################################
# Build
#############################################
FROM --platform=$BUILDPLATFORM golang:1.18-alpine as build

RUN apk upgrade --no-cache --force
RUN apk add --update build-base make git

WORKDIR /app

# Compile
COPY . .
RUN make
ARG TARGETOS TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} make 



#############################################
# Final
#############################################
FROM golang:1.18-alpine 
ENV LOG_JSON=1
WORKDIR /app 
COPY --from=build /app/alertmanager2es .
USER 1000:1000


ENTRYPOINT ["/app/alertmanager2es"]
