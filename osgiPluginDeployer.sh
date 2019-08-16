#!/usr/bin/env bash

set -Eeo pipefail

if [[ $# < 5 ]] ; then
    echo "Use: ./osgiPluginDeployer.sh host port bundleName level serverJarPath"
    echo "Example: ./osgiPluginDeployer.sh 127.0.0.1 12612 com.ingeint.template 5 /plugins/com.ingeint.template-6.2.0-SNAPSHOT.jar"
    if [[ "$1" == "--help" ]]; then
      exit 0
    else
      exit 1
    fi
fi

host=$1
port=$2
bundleName=$3
level=$4
jarFile=$5

function ss() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "ss\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function install() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "install file:${jarFile}\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function uninstall() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "uninstall $(getId)\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function setbsl() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "setbsl ${level} $(getId)\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function start() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "start $(getId)\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function getId() {
    ss | grep "${bundleName}_" | awk '{print $1}'
}

function getStatus() {
    ss | grep "${bundleName}_" | awk '{print $2}'
}

uninstall
sleep 2
install
sleep 2
setbsl
sleep 2
start
sleep 2

echo "$(ss | grep "${bundleName}_")"

if [[ "$(getStatus)" != "ACTIVE" ]] ; then
  echo "Status is not active" ; exit 1
fi
