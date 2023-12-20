build:
	@docker run --rm -v $(CURDIR):/var/task public.ecr.aws/sam/build-ruby3.2  ./build.sh
