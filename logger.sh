# EasyColors
if [ ${libout_color:-1} -eq 1 ]; then
  DEF_COLOR="\x1B[0m"
  BLUE="\x1B[34;01m"
  CYAN="\x1B[36;01m"
  GREEN="\x1B[32;01m"
  RED="\x1B[31;01m"
  GRAY="\x1B[37;01m"
  YELLOW="\x1B[33;01m"
  DIM="\x1B[2m"
fi

timestamp() {
  echo "[${DIM}$(date +%H:%M:%S)${DEF_COLOR}]"
}

debug() {
  if [ ${verbose_level:-0} -gt 3 ]; then
    echo -e "$(timestamp) ${CYAN}$@${DEF_COLOR}"
  fi
}

info() {
  if [ ${verbose_level:-0} -gt 2 ]; then
    echo -e "$(timestamp) ${GREEN}$@${DEF_COLOR}"
  fi
}

warn() {
  if [ ${verbose_level:-0} -gt 1 ]; then
    echo -e "$(timestamp) ${YELLOW}$@${DEF_COLOR}"
  fi
}

message() {
  if [ ${verbose_level:-0} -gt 0 ]; then
    echo -e "$(timestamp) ${GREEN}$@${DEF_COLOR}"
  fi
}

error() {
  echo -e "$(timestamp) ${RED}$@${DEF_COLOR}"
}

die() {
  error "$(timestamp) $@"
  exit 1
}

loggerSourced() {
  info "Logger.sh is sourced"
}
