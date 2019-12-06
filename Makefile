.PHONY: build develop-docker deploy

PROJECT:=kurrik-apps
SERVICE:=laulik-server

develop-docker:
	docker build . --tag gcr.io/${PROJECT}/${SERVICE}
	PORT=8080 && docker run \
		-p 8080:$${PORT} \
		-e PORT=$${PORT} \
		gcr.io/${PROJECT}/${SERVICE}

build:
	gcloud builds submit \
		--project ${PROJECT} \
		--timeout "10m" \
		--tag gcr.io/${PROJECT}/${SERVICE} \
		.

deploy:
	gcloud beta run deploy \
		${SERVICE} \
		--project ${PROJECT} \
		--region us-central1 \
		--allow-unauthenticated \
		--image gcr.io/${PROJECT}/${SERVICE} \
		--platform managed \
		--update-env-vars ${ENV}
