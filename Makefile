REMOTE_SERVER     ?= frodo
REMOTE_USER       ?= wally
REMOTE_WWWROOT    ?= /www/htdocs/wallyjones.com/

LOCAL_PORT ?= 8080


.PHONY: server confirm publish

help: 
	@echo "Makefile for wallyjones.com. Check Makefile for variables.\n"
	@echo "Usage:"
	@echo "\tmake serve  \tpython http.server on ${LOCAL_PORT} to locally test"
	@echo "\tmake publish \ttar files over SSH to ${REMOTE_WWWROOT} on ${REMOTE_SERVER}"

serve:
	python -m http.server ${LOCAL_PORT}

confirm:
	@echo "Are you sure you want to publish? [y/n] " && read ans && [ $${ans:-N} = y ]

publish: confirm
	@echo "Publishing to ${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_WWWROOT}..."
	@COPYFILE_DISABLE=1 tar -X tar-exclude.txt \
		-cf - . | ssh ${REMOTE_USER}@${REMOTE_SERVER} "tar -xf - -C ${REMOTE_WWWROOT}"
