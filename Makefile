build:
	@ docker build -t idempiere-deployer:latest .

bash:
	@ docker run -it --rm --network host --entrypoint bash idempiere-deployer

run:
	@ docker run -it --rm --network host idempiere-deployer
