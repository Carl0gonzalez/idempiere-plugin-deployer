#!/usr/bin/env bash

set -Eeo pipefail

function validateHost() {
    if [[ "${host}" == "" ]] ; then
        echo "Invalid Option: $subcommand requires an argument -h"
        exit 1
    fi
}

function validatePort() {
    if [[ "${port}" == "" ]] ; then
        echo "Invalid Option: $subcommand requires an argument -p"
        exit 1
    fi
}

function validateBundleName() {
    if [[ "${bundleName}" == "" ]] ; then
        echo "Invalid Option: $subcommand requires an argument -n"
        exit 1
    fi
}

function validateLevel() {
    if [[ "${level}" == "" ]] ; then
        echo "Invalid Option: $subcommand requires an argument -l"
        exit 1
    fi
}

function validateJarFile() {
    if [[ "${jarFile}" == "" ]] ; then
        echo "Invalid Option: $subcommand requires an argument -j"
        exit 1
    fi
}

function ss() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "ss\r"
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

function install() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "install file:${jarFile}\r"
expect -re "osgi>"
send "disconnect\r"
EOF
}

function refresh() {
    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "refresh \r"
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

function deploy() {
    uninstall
    install
    setbsl
    start
    
    echo "$(ss | grep "${bundleName}_")"

    if [[ "$(getStatus)" != "ACTIVE" ]] ; then
        echo "Status is not active" ; exit 1
    fi
}

function full_deploy() {

    expect << EOF
spawn telnet ${host} ${port}
expect -re "osgi>"
send "uninstall $(getId)\r"
expect -re "osgi>"
send "install file:${jarFile}\r"
expect -re "osgi>"
send "disconnect\r"
spawn telnet ${host} ${port}
send "setbsl ${level} $(getId)\r"
expect -re "osgi>"
send "start $(getId)\r"
expect -re "osgi>"
send "disconnect\r"
EOF
echo "$(ss | grep "${bundleName}_")"

    if [[ "$(getStatus)" != "ACTIVE" ]] ; then
        echo "Status is not active" ; exit 1
    fi
}

    

function fragment() {
    uninstall
    sleep 2
    install
    sleep 2
    setbsl
    sleep 2
    refresh  

    echo "$(ss | grep "${bundleName}_")"

    if [[ "$(getStatus)" != "RESOLVED" ]] ; then
        echo "Fragment not active" ; exit 1
    fi
}

function help() {
    command="./deployer.sh"
    if [[ "$IS_DOCKER" == "true" ]] ; then
        command="docker run -it --rm --network host idempiere-deployer"
    fi
    echo "Usage:"
    printf "    Display this help message:\n                $command\n                $command -h\n"
    printf "    Show plugins list:\n                $command ss -h <host> -p <port>\n"
    printf "    Show plugin's id:\n                $command id -h <host> -p <port> -n <name>\n"
    printf "    Show plugin's status:\n                $command status -h <host> -p <port> -n <name>\n"
    printf "    Deploy a plugin:\n                $command deploy -h <host> -p <port> -n <name> -l <level> -j <jar>\n"
    exit 0
}

if [[ $# == 0 ]] ; then
    help
fi

while getopts ":h" opt; do
    case ${opt} in
        h )
            help
            ;;
        ? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

subcommand=$1; shift
case "$subcommand" in
    ss)
        while getopts ":h:p:" opt; do
            case ${opt} in
                h )
                    host=$OPTARG
                    ;;
                p )
                    port=$OPTARG
                    ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                    ;;
                ? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))
        validateHost
        validatePort
        ss
        ;;
    id)
        while getopts ":h:p:n:" opt; do
            case ${opt} in
                h )
                    host=$OPTARG
                    ;;
                p )
                    port=$OPTARG
                    ;;
                n )
                    bundleName=$OPTARG
                    ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                    ;;
                ? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))
        validateHost
        validatePort
        validateBundleName
        getId
        ;;
    status)
        while getopts ":h:p:n:" opt; do
            case ${opt} in
                h )
                    host=$OPTARG
                    ;;
                p )
                    port=$OPTARG
                    ;;
                n )
                    bundleName=$OPTARG
                    ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                    ;;
                ? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))
        validateHost
        validatePort
        validateBundleName
        getStatus
        ;;
    deploy)
        while getopts ":h:p:n:l:j:" opt; do
            case ${opt} in
                h )
                    host=$OPTARG
                    ;;
                p )
                    port=$OPTARG
                    ;;
                n )
                    bundleName=$OPTARG
                    ;;
                l )
                    level=$OPTARG
                    ;;
                j )
                    jarFile=$OPTARG
                    ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                    ;;
                ? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))
        validateHost
        validatePort
        validateBundleName
        validateLevel
        validateJarFile
        deploy
        ;;
            fragment)
        while getopts ":h:p:n:l:j:" opt; do
            case ${opt} in
                h )
                    host=$OPTARG
                    ;;
                p )
                    port=$OPTARG
                    ;;
                n )
                    bundleName=$OPTARG
                    ;;
                l )
                    level=$OPTARG
                    ;;
                j )
                    jarFile=$OPTARG
                    ;;
                : )
                    echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                    exit 1
                    ;;
                ? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))
        validateHost
        validatePort
        validateBundleName
        validateLevel
        validateJarFile
        fragment
        ;;
    *)
        echo "Invalid Option: $subcommand" 1>&2
        exit 1
        ;;
esac
