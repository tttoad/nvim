.PHONY: buildBaseImage
buildBaseImage: 
	docker build --network=host --no-cache -f ./docker/baseDockerfile -t base/image:latest . 

.PHONY: buildDebugGoImage
buildDebugGoImage:
	@if [ ! -f .buildBaseTime ] || [ $$(cat .buildBaseTime) -lt $$(stat -f %Dc ./docker/baseDockerfile) ]; then \
		echo $$(date +%s) > .buildBaseTime ; \
		make buildBaseImage ;\
	fi
	docker build --no-cache --network=host -f ./docker/debugGoDockerfile -t debug/go:latest .

.PHONY: runDebugGoImage
runDebugGoImage:
	docker run -v $(TAR):$(SOURCE) -v $(DELVE):/root/delve -w $(TAR) -p 38697:38697 debug/go:latest /bin/bash -c "dlv dap -l 127.0.0.1:38697 --log --log-output="dap""

.PHONY: test
test:
	@echo a=1
