FROM mcr.microsoft.com/devcontainers/base:jammy

RUN <<EOF
set -e
apt-get update
apt-get -y install bash-completion 
rm -rf /var/lib/apt/lists/*
EOF

# eksctl
RUN <<EOF
set -e
arch=$(uname -m)
if [ "$arch" = "aarch64" ]; then
    arch="arm64"
fi
platform="$(uname -s)_${arch}"
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${platform}.tar.gz"
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "$platform" | sha256sum --check
tar -xzf eksctl_"$platform".tar.gz -C /tmp && rm eksctl_"$platform".tar.gz
mv /tmp/eksctl /usr/local/bin
EOF

# xdg-open
RUN <<EOF
set -e
cat << 'EOF2' > /usr/local/bin/xdg-open
#!/usr/bin/env bash
"${BROWSER}" "${@}"
EOF2
chmod +x /usr/local/bin/xdg-open
EOF

# Install AWS SSM Plugin
RUN <<EOF
set -e
ARCH=$(uname -m)
ARCH_SUFFIX=$( [ "$ARCH" = "x86_64" ] && echo "64bit" || echo "arm64" )
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_${ARCH_SUFFIX}/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb
EOF
