# frank-knife

[Frank](https://www.yantao0527.me) personal suit tools.

- v2ray (https://www.yantao0527.me/#/v2ray)

## Hands-on

- gitea
  - register a user
  - Settings - Manage SSH Keys - Add Key
  - New Respository
  - Import Repository

## Devcontainer

- Sharing Git credentials with your container. 
  The Remote - Containers extension provides out of box support for using local Git credentials from inside a container.
  The extension will automatically copy your local .gitconfig file into the container on startup so you should not need to do this in the container itself.
- Using SSH keys.
  There are some cases when you may be cloning your repository using SSH keys instead of a credential helper. To enable this scenario, the extension will automatically forward your local SSH agent if one is running.

  ## V2ray

  - Add `Environment="V2RAY_VMESS_AEAD_FORCED=false"` into /etc/systemd/system/v2ray.service to support v2rayX on macOS. [guid](https://github.com/v2fly/v2ray-core/discussions/1514)