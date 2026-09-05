.PHONY: test image local-up local-down smoke helm-check tf-check

test:
	mvn -B -f app/pom.xml clean verify

image:
	docker build -t order-service:local .

local-up:
	docker compose up --build -d

local-down:
	docker compose down

smoke:
	./scripts/smoke-test.sh

helm-check:
	helm lint gitops-repository/charts/order-service -f gitops-repository/charts/order-service/values-dev.yaml
	helm template orders-dev gitops-repository/charts/order-service -f gitops-repository/charts/order-service/values-dev.yaml >/tmp/order-service-rendered.yaml

tf-check:
	terraform -chdir=infra/terraform fmt -check
	terraform -chdir=infra/terraform init -backend=false
	terraform -chdir=infra/terraform validate
