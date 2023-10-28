#!/bin/bash
#!/bin/sh
set -eu

# Allow users to have scripts run on container startup to prepare workspace.
# https://github.com/coder/code-server/issues/5177
if [ -d "${ENTRYPOINTD}" ]; then
  find "${ENTRYPOINTD}" -type f -executable -print -exec {} \;
fi
echo "root:123" | chpasswd
/usr/sbin/sshd
chown coder:coder /home/coder
command="exec /usr/bin/code-server $@"
su coder -c "${command}"
