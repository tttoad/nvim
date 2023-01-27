.PHONY: buildBaseImage
buildBaseImage: 
	docker build -f ./docker/baseDockerfile -t base/image:latest . 

.PHONY: buildDebugGoImage
buildDebugGoImage:
	@if [ ! -f .buildBaseTime ] || [ $$(cat .buildBaseTime) -lt $$(stat -f %Dc ./docker/baseDockerfile) ]; then \
		echo $$(date +%s) > .buildBaseTime ; \
		make buildBaseImage ;\
	fi
	docker build --no-cache --network=host -f ./docker/debugGoDockerfile -t debug/go:latest .

.PHONY: test
test:
	@echo a=1
