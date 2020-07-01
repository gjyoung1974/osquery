# osquery
## customized image

<p align="center">
<img alt="osquery logo" width="200"
src="https://github.com/facebook/osquery/raw/master/docs/img/logo-2x-dark.png" />
</p>

This repository is patched to change the default mountpoint for the linux /proc filesystem.
The mountpoint for /proc has been moved to /host/proc in order to query the kubernetes host vs the pod.

See [README.md](./README.md.old)

---
