FROM	docker.io/rootwyrm/tc_mono:latest
MAINTAINER	Phillip "RootWyrm" Jaenke <talecaster@rootwyrm.com>

LABEL	com.rootwyrm.product="TaleCaster" \
		com.rootwyrm.project="tc_sonarr" \
		com.rootwyrm.status="" \
		com.rootwyrm.vcs-type="github" \
		com.rootwyrm.changelog-url="https://github.com/rootwyrm/talecaster/CHANGELOG" \
		com.rootwyrm.nvd.release="0" \
		com.rootwyrm.nvd.version="0" \
		com.rootwyrm.nvd.update="0" \
		com.rootwyrm.nvd.update_sub="$RW_VCSHASH" \
		com.rootwyrm.nvd.build_time="$LS_BLDDATE" \

		com.rootwyrm.talecaster.provides="sonarr" \
		com.rootwyrm.talecaster.depends="bittorrent nntp" \
		com.rootwyrm.talecaster.service="sonarr" \
		com.rootwyrm.talecaster.ports_tcp="8989" \
		com.rootwyrm.talecaster.ports_udp="" \
		com.rootwyrm.talecaster.synology="0" \
		com.rootwyrm.talecaster.qnap="0" \

		org.label-schema.schema-version="$LS_SCHEMAVERSION" \
		org.label-schema.vendor="$LS_VENDOR" \
		org.label-schema.name="$LS_NAME" \
		org.label-schema.url="$LS_URL" \
		org.label-schema.vcs-ref="$VCS_REF" \
		org.label-schema.version="$RW_BLDHASH" \
		org.label-schema.build-date="$LS_BLDDATE"

## PORTS
EXPOSE	8989/tcp 

## Common Components
COPY [ "application/", "/opt/talecaster" ]
COPY [ "sv/", "/etc/sv" ]

## Application and Supporting Tools
ENV pkg_application="git wget"
RUN	apk add --no-cache $pkg_application ; \
	apk add --no-cache --virtual vp_python_base python && \
	cp /opt/talecaster/python/sitecustomize.py /usr/lib/python2.7/site-packages/sitecustomize.py ; \
	for bld in `ls /opt/talecaster/build/ | sort`; do \
		/opt/talecaster/build/$bld ; \
	done 

ADD	README.md /README.md

## Special Volumes
VOLUME [ "/media/television" ]

## Reset state on build
ONBUILD CMD touch /firstboot

## Terminus
CMD [ "/sbin/runsvdir", "-P", "/etc/service" ]
