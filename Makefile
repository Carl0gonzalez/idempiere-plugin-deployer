build:
	@ docker build -t idempiere-deployer:latest .

bash:
	@ docker run -it --rm --network host idempiere-deployer bash

help:
	@ docker run -it --rm --network host idempiere-deployer
