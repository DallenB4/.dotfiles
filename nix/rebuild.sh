#!/run/current-system/sw/bin/bash
set -E
set -o pipefail
tput smcup
clear
cd $(dirname "$0")
git -P diff -U0
NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
C_RED="\033[38;5;9m"
C_GREEN="\e[1;32m"
echo -e "${F_BOLD}${C_GREEN}\n####################\n# Rebuilding NixOS #\n####################${NO_FORMAT}"

REBUILD_CMD="switch"
if [ "$1" == "test" ] || [ "$1" == "boot" ]; then
	REBUILD_CMD="$1"
fi

sudo nixos-rebuild $REBUILD_CMD --show-trace --option eval-cache false --flake . |& tee nixos-switch.log
if [ $? -ne 0 ]; then
  tput rmcup
  echo -e "${F_BOLD}${C_RED}\nError while building!\n${NO_FORMAT}"
  grep error nixos-switch.log
  cd -
  exit -1 
fi
if [ "$REBUILD_CMD" == "switch" ] || [ "$REBUILD_CMD" == "boot" ]; then
	printf "\r\n"
	gen=$(nixos-rebuild list-generations | grep current)
	git commit -am "$gen"
fi

tput rmcup

echo -e "${F_BOLD}${C_GREEN}\nBuild Successful!${NO_FORMAT}"
./sync.sh
cd -
