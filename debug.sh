#!/usr/bin/env bash

# https://stackoverflow.com/a/246128/329496
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# source ${DIR}/src/_utils/_git_secret_tools_freebsd.sh
# source ${DIR}/src/_utils/_git_secret_tools_linux.sh
source ${DIR}/src/_utils/_git_secret_tools_osx.sh
source ${DIR}/src/_utils/_git_secret_tools.sh
# source ${DIR}/src/main.sh
source ${DIR}/src/version.sh
source ${DIR}/src/commands/git_secret_whoknows.sh
source ${DIR}/src/commands/git_secret_usage.sh
source ${DIR}/src/commands/git_secret_init.sh
source ${DIR}/src/commands/git_secret_tell.sh
source ${DIR}/src/commands/git_secret_killperson.sh
source ${DIR}/src/commands/git_secret_hide.sh
source ${DIR}/src/commands/git_secret_changes.sh
source ${DIR}/src/commands/git_secret_reveal.sh
source ${DIR}/src/commands/git_secret_remove.sh
source ${DIR}/src/commands/git_secret_add.sh
source ${DIR}/src/commands/git_secret_cat.sh
source ${DIR}/src/commands/git_secret_list.sh
source ${DIR}/src/commands/git_secret_clean.sh

cd ${DIR}/shared/gpg2.2

PWD=$(pwd)

#tell "initrd@gmail.com"
hide -m
