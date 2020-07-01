all:  osqueryds

IMAGE := gjyoung1974/osqueryds-build-deb:latest

osqueryds:
	docker build --pull --rm --label org.label-schema.vcs-url=https://github.com/postmates/pi-k8s.git  -f "Dockerfile" --tag $(IMAGE) "."

cloud:
	gcloud builds submit --config cloudbuild.yaml --timeout=3h

buildlocal:
	cd local && wget https://github.com/osquery/osquery-toolchain/releases/download/1.1.0/osquery-toolchain-1.1.0-x86_64.tar.xz	\
	&& tar xvf osquery-toolchain-1.1.0-x86_64.tar.xz -C /usr/local	\
	&& wget https://github.com/Kitware/CMake/releases/download/v3.14.6/cmake-3.14.6-Linux-x86_64.tar.gz	\
	&& tar xvf cmake-3.14.6-Linux-x86_64.tar.gz -C /usr/local --strip 1	\
	&& git clone https://github.com/gjyoung1974/osquery.git	\
	&& cd osquery  \
	&& mkdir -p ./osquery/build; cd ./osquery/build \
	&& cmake -DOSQUERY_TOOLCHAIN_SYSROOT=/usr/local/osquery-toolchain .. \
	&& cmake -DPACKAGING_SYSTEM=DEB ..  \
	&& cmake --build . --target package -j10
