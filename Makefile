CLUSTER := local
CONTEXT := k3d-$(CLUSTER)
K3S_IMAGE := rancher/k3s:v1.37.2-k3s1
ARGOCD_CHART_VERSION := 10.20.0

.PHONY: up
up:
	@k3d cluster get $(CLUSTER) >/dev/null 2>&1 || \
		k3d cluster create $(CLUSTER) --image $(K3S_IMAGE) --port "80:80@loadbalancer" --wait
	@helm upgrade --install argocd argo-cd --kube-context $(CONTEXT) \
		--repo https://argoproj.github.io/argo-helm --version $(ARGOCD_CHART_VERSION) \
		-n argocd --create-namespace -f argocd/values.yaml --wait
	@kubectl --context $(CONTEXT) apply -f apps.yaml

.PHONY: down
down:
	@k3d cluster delete $(CLUSTER)

.PHONY: lint
lint:
	@kubeconform -strict \
		-schema-location default \
		-schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
		-ignore-filename-pattern '(^|/)values(/|\.yaml$$)' \
		-ignore-filename-pattern '(^|/)\.' \
		-summary \
		.
	@yamllint .
