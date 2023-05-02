#!/bin/zsh

ensure_usr_local_bin_is_in_path() {
  if [[ ! $PATH =~ "/usr/local/bin" ]]; then
    echo "⚠️ '/usr/local/bin' is not included in PATH environment variable."
    echo "  👉 Add 'PATH=\$PATH:/usr/local/bin' in your ~/.zshrc or ~/.zprofile file and reload the shell."
    return 1
  else
    return 0
  fi
}

ensure_brew_is_installed() {
  if ! command -v brew &> /dev/null; then
    echo "⚠️ 'brew' is not installed."
    echo "  👉 Run '/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"' to install."
    return 1
  else
    return 0
  fi
}

ensure_bundler_is_installed() {
  if ! command -v bundle &> /dev/null; then
    echo "⚠️ 'bundler' is not installed."
    echo "  👉 Run 'gem install bundler' to install."
    return 1
  else
    return 0
  fi
}

ensure_ruby_deps_are_installed() {
  bundle
}

ensure_npm_is_installed() {
  if ! command -v npm &> /dev/null; then
    echo "⚠️ 'node' is not installed."
    echo "  👉 Run 'brew install node' to install."
    return 1
  else
    return 0
  fi
}

ensure_grunt_cli_is_installed() {
  if ! command -v grunt &> /dev/null; then
    echo "⚠️ 'grunt-cli' is not installed."
    echo "  👉 Run 'npm install -g grunt-cli' to install."
    return 1
  else
    return 0
  fi
}

ensure_local_grunt_is_installed() {
  if [[ ! -d node_modules/grunt ]]; then
    echo "⚠️ local 'grunt' npm module is not installed."
    echo "  👉 Run 'npm install' to install."
    return 1
  else
    return 0
  fi
}

ensure_tuist_is_installed() {
  if ! command -v tuist &> /dev/null; then
    echo "⚠️ 'tuist' is not installed."
    echo "  👉 Run 'curl -Ls https://install.tuist.io | bash' to install."
    return 1
  else
    tuist bundle
    return 0
  fi
}

configure_git_hooks() {
  git config core.hooksPath ./git-hooks
}

ensure_usr_local_bin_is_in_path
e1=$?

ensure_brew_is_installed
e2=$?

ensure_bundler_is_installed
e3=$?

ensure_ruby_deps_are_installed
e4=$?

ensure_npm_is_installed
e5=$?

ensure_grunt_cli_is_installed
e6=$?

ensure_local_grunt_is_installed
e7=$?

ensure_tuist_is_installed
e8=$?

if [[ $(($e1+$e2+$e3+$e4+$e5+$e6+$e7+$e8)) -gt 0 ]]; then
  exit 1
fi

configure_git_hooks
