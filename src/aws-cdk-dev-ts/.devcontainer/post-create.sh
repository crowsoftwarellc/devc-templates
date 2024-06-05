#!/usr/bin/env bash
#----------------------------------------------------------------------------
# Run after container creation to initialize things not in the repo.
#----------------------------------------------------------------------------

# Setup .bashrc with path, autocompletions, vars
sed -i '/^#--DEVC-BEGIN/,/^#--DEVC-END/ d' ~vscode/.bashrc
cat << 'EOF' >> ~vscode/.bashrc
#--DEVC-BEGIN
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.guard/bin:$PATH"
source <(kubectl completion bash)
source <(eksctl completion bash)
source <(helm completion bash)
alias k=kubectl
alias kn='kubectl config set-context --current --namespace'
complete -F __start_kubectl k
complete -C "$(which aws_completer)" aws
export PACKAGE_TOKEN=$(gh auth token)
#--DEVC-END
EOF

# Install kubectl krew for easy plugin installation
# Installing here for user but should eventually go in Dockerfile if there's
#  no dependency on kubectl for the install.
(
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
)

if ! gh auth status | grep -q 'Token.*project.*read:packages'; then
    gh auth login --web --git-protocol https --hostname github.com --scopes project,read:packages
fi

gh auth setup-git
