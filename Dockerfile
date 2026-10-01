FROM ghcr.io/home-assistant/home-assistant:stable

# /config is a PVC at runtime, so anything copied there would be hidden by
# the mount. Ship the starting configuration in /defaults instead; the
# Deployment's initContainer copies it into the PVC on first start only.
COPY configuration.yaml /defaults/configuration.yaml
