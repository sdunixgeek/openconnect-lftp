#!/bin/sh
# Environment variables
vpnUser="${oc_vpnUser:-}"
vpnPass="${oc_vpnPass:-}"
vpnServer="${oc_vpnServer:-}"
vpnProtocol="${oc_vpnProtocol:-anyconnect}"
vpnPIDFile="${oc_vpnPIDFile:-/tmp/ocpid.txt}"
ftpUser="${oc_ftpUser:-}"
ftpPass="${oc_ftpPass:-}"
ftpHost="${oc_ftpHost:-}"
ftpRemDir="${oc_ftpRemDir:-}"
ftpHostDir="${oc_ftpHostDir:-}"
ftpParallel="${oc_ftpParallel:-8}"

########################################
# Start Openconnect to server in background
# Arguments:
#  $1 vpnUser name
#  $2 vpnPass password
#  $3 vpnServer vpn host name to connect to
#  $4 vpnProtocol defaults to anyconnect
# Outputs:
#  Starting connection notice
# Returns:
#   returns success or fail after starting openconnect.
########################################
startVpn () {
  vpnUser="${1}"
  vpnPass="${2}"
  vpnServer="${3}"
  vpnProtocol="${4:-anyconnect}"
  vpnPIDFile="${5:-/tmp/ocpid.txt}"
  echo "Starting openconnect VPN client..."
  echo "${vpnPass}" | \
    openconnect "${vpnServer}" \
      --protocol="${vpnProtocol}" \
      --user="${vpnUser}" \
      --quiet \
      --background \
      --pid-file="${vpnPIDFile}" \
      --passwd-on-stdin
  vpnSecs=30
  vpnEndTime=$(( $(date +%s) + vpnSecs ))
  while [ "$(date +%s)" -lt $vpnEndTime ]; do
    [ -s "$vpnPIDFile" ] && vpnPID=$(cat "${vpnPIDFile}")
    [ -n "${vpnPID}" ] && [ -e /proc/"${vpnPID}" ] && return 0
  done
  return 1
}
transferFiles () {
  ftpUser="${1}"
  ftpPass="${2}"
  ftpHost="${3}"
  ftpRemDir="${4}"
  ftpHostDir="${5}"
  ftpParallel="${6:-8}"
  printf "Starting lftp transfer of all NEW files in specified directory %s\n" "${ftpRemDir}"
  ftpArgs="set ftp:ssl-allow no; lcd /${ftpHostDir}; cd \'${ftpRemDir}\'; mirror --continue --only-newer --verbose=3 --no-perms --parallel=${ftpParallel} --ascii --include-glob *; exit"
  lftp ftp://"${ftpUser}":"${ftpPass}"@"${ftpHost}" -e "$(printf '%s' "${ftpArgs}")" > /tmp/lftp_output.txt 2>&1
  printf "Completed lftp transfer of all NEW files in specified directory %s\n" "${ftpRemDir}"
  cat /tmp/lftp_output.txt
}
if startVpn "${vpnUser}" "${vpnPass}" "${vpnServer}" "${vpnProtocol}" "${vpnPIDFile}"; then
  transferFiles "${ftpUser}" "${ftpPass}" "${ftpHost}" "${ftpRemDir}" "${ftpHostDir}" "${ftpParallel}"
else
  echo "Failed to start vpn"
  exit 1
fi
