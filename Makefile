all:  osqueryds

IMAGE := gjyoung1974/osqueryds-build-deb:latest

osqueryds:
	docker build --pull --rm --label org.label-schema.vcs-url=https://github.com/postmates/pi-k8s.git  -f "Dockerfile" --tag $(IMAGE) "."

cloudbuild:
	gcloud builds submit --config cloudbuild.yaml
	