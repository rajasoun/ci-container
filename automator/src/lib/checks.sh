#!/usr/bin/env bash


# promt error message and exit
function raise_error(){
  echo -e "${RED}${1}${NC}" >&2
  EXIT_CODE=1
  log_sentry "$EXIT_CODE" "${RED}${1}${NC}"
  exit 1
}

# Checks if the commands jq, openssl and docker are found
function check_preconditions() {
  _is_command_found jq
  _is_command_found openssl
  # _is_command_found docker
  _is_command_found sfdx
  _is_command_found cci
  prompt "Preconditions Check ✅"
  return 0
}

# Wrapper To Aid TDD
function _run_main(){
    _is_org_alias_set "$@"
    raise_error "$@"
    check_preconditions "$@"
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! _run_main "$@"
  then
    exit 1
  fi
fi
