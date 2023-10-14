.PHONY: buildBaseImage buildDebugGoImage 

buildBaseImage: 
	docker build --network=host --no-cache -f ./docker/baseDockerfile -t base/image:latest . 

buildDebugGoImage:
	@if [ ! -f .buildBaseTime ] || [ $$(cat .buildBaseTime) -lt $$(stat -f %Dc ./docker/baseDockerfile) ]; then \
		echo $$(date +%s) > .buildBaseTime ; \
		make buildBaseImage ;\
	fi
	docker build --no-cache --network=host -f ./docker/debugGoDockerfile -t debug/go:latest .

.PHONY:runDebugGoImage stopDebugGoImage

runDebugGoImage:
	docker run -v $(TAR):$(SOURCE) -v $(DELVE):/root/delve -w $(TAR) -p 38697:38697 -d --name $(PROJECT)debug/go:latest 

stopDebugGoImage:
	docker stop $(PROJECT) | xargs docker rm

.PHONY: test
test:
	@echo a=1
