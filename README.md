# iDempiere Plugin Deployer

This tool allows you connect to iDempiere's OSGI platform and deploy a plugin, it's useful for continuous integration platforms.

### Usage:

```
Usage:
    ./deployer -h
                [Display this help message]
    ./deployer.sh ss -h <host> -p <port>
                [Show plugins list]
    ./deployer.sh id -h <host> -p <port> -n <name>
                [Show plugin's id]
    ./deployer.sh status -h <host> -p <port> -n <name>
                [Show plugin's status]
    ./deployer.sh deploy -h <host> -p <port> -n <name> -l <level> -j <jar>
                [Deploy a plugin]
```

### Example:

```
./deployer.sh deploy -h 127.0.0.1 -p 12612 -n com.ingeint.template -l 5 -j /plugins/com.ingeint.template-6.2.0-SNAPSHOT.jar
```
