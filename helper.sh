# Useful helpers.
text () {
  printf "    $1\n"
}

info () {
  printf "\033[1;34m==>\033[0m $1\n"
}

error () {
  printf "\033[31m[✗]\033[0m $1\n"
}

success () {
  printf "\033[32m[✔]\033[0m $1\n"
}

hasCommand() {
  if command -v $1 > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}
