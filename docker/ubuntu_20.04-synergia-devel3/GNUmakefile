# Put whatever name makes sense for the image here. No spaces or funny
# characters.
NAME = fnalacceleratormodeling/ubuntu20.04-synergia3

# Remember to increment VERSION as you make new versions.
VERSION = 0.0.6

.PHONY: all build tag_latest release test shell

all: build

build:
	docker build --tag $(NAME):$(VERSION) $(PWD)

tag_latest: build
	docker tag $(NAME):$(VERSION) $(NAME):latest

shell-linux:
	docker run -it --rm \
    --env="DISPLAY" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--privileged \
		$(NAME):$(VERSION)

shell-macos:
	docker run -it --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--privileged \
		$(NAME):$(VERSION)

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME):$(VERSION)
	docker push $(NAME):latest
