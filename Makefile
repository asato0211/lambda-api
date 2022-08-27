build:
	@docker run --rm -v $(CURDIR):/var/task amazon/aws-sam-cli-build-image-ruby2.7  ./build.sh
