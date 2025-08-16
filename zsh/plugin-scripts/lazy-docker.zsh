# Lazy-load docker/docker-compose OMZ plugins only when inside a project with Docker files
# Moves logic out of .zshrc to keep it minimal.

lazy_load_docker_plugins() {
    local dir="$PWD"
    while [[ "$dir" != "/" && -n "$dir" ]]; do
        if [[ -f "$dir/Dockerfile" || -f "$dir/docker-compose.yml" || -f "$dir/docker-compose.yaml" || -f "$dir/.dockerignore" ]]; then
            if [[ -z "$DOCKER_PLUGINS_LOADED" ]]; then
                DOCKER_PLUGINS_LOADED=1
                # defer so it won't block startup
                if typeset -f zdefer >/dev/null; then
                    [[ -r "${ZSH}/plugins/docker/docker.plugin.zsh" ]] && zdefer -t 0.2 eval "source '${ZSH}/plugins/docker/docker.plugin.zsh'"
                    [[ -r "${ZSH}/plugins/docker-compose/docker-compose.plugin.zsh" ]] && zdefer -t 0.3 eval "source '${ZSH}/plugins/docker-compose/docker-compose.plugin.zsh'"
                else
                    [[ -r "${ZSH}/plugins/docker/docker.plugin.zsh" ]] && source "${ZSH}/plugins/docker/docker.plugin.zsh"
                    [[ -r "${ZSH}/plugins/docker-compose/docker-compose.plugin.zsh" ]] && source "${ZSH}/plugins/docker-compose/docker-compose.plugin.zsh"
                fi
            fi
            return 0
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd lazy_load_docker_plugins
# run once for the current directory at startup
lazy_load_docker_plugins
