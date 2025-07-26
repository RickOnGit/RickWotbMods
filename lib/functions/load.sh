function load() {
  set -a

  for file in /opt/RickWotbMods/lib/env/*.env; do
    [[ -f "$file" ]] && source "$file"
  done

  for file in /opt/RickWotbMods/lib/functions/*.sh; do
    [[ -f "$file" ]] && source "$file"
  done

  for file in /opt/RickWotbMods/lib/extra/*.sh; do
    [[ -f "$file" ]] && source "$file"
  done

  set +a
}
