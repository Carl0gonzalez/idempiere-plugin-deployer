# Quick reference

- **Maintained by**:  
  [INGEINT](https://ingeint.com)

- **Where to file issues**:  
  [Mattermost Support Channel](https://mattermost.idempiere.org/idempiere/channels/support) or [Github Issues](https://github.com/ingeint/idempiere-plugin-deployer/issues)

- **Official Links**:  
  [Dockerhub](https://hub.docker.com/r/ingeinthub/idempiere-plugin-deployer),
  [Github](https://github.com/ingeint/idempiere-plugin-deployer),
  [iDempiere](https://github.com/idempiere/idempiere)

# iDempiere Plugin Deployer

This tool allows you connect to iDempiere's OSGI platform and deploy a plugin, it's useful for continuous integration platforms.

## Before to start

Installing dependencies:

```
apt-get install telnet expect
```

## Bash

### Usage:

```
Display this help message:
            ./deployer
            ./deployer -h
Show plugins list:
            ./deployer.sh ss -h <host> -p <port>
Show plugin's id:
            ./deployer.sh id -h <host> -p <port> -n <name>
Show plugin's status:
            ./deployer.sh status -h <host> -p <port> -n <name>
Deploy a plugin:
            ./deployer.sh deploy -h <host> -p <port> -n <name> -l <level> -j <jar>
```

### Example:

```
./deployer.sh deploy -h 127.0.0.1 -p 12612 -n com.ingeint.template -l 5 -j /plugins/com.ingeint.template-7.1.0-SNAPSHOT.jar
```

## Docker

### Usage:

```
Display this help message:
            docker run -it --rm --network host idempiere-deployer
            docker run -it --rm --network host idempiere-deployer -h
Show plugins list:
            docker run -it --rm --network host idempiere-deployer ss -h <host> -p <port>
Show plugin's id:
            docker run -it --rm --network host idempiere-deployer id -h <host> -p <port> -n <name>
Show plugin's status:
            docker run -it --rm --network host idempiere-deployer status -h <host> -p <port> -n <name>
Deploy a plugin:
            docker run -it --rm --network host idempiere-deployer deploy -h <host> -p <port> -n <name> -l <level> -j <jar>

```

### Example:

```
docker run -it --rm --network host idempiere-deployer deploy -h 127.0.0.1 -p 12612 -n com.ingeint.template -l 5 -j /plugins/com.ingeint.template-7.1.0-SNAPSHOT.jar
```
