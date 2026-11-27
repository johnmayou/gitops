CLUSTER := local
K3S_IMAGE := rancher/k3s:v1.37.2-k3s1

.PHONY: up
up:
	@k3d cluster get $(CLUSTER) >/dev/null 2>&1 || \
		k3d cluster create $(CLUSTER) --image $(K3S_IMAGE) --port "80:80@loadbalancer" --wait

.PHONY: down
down:
	@k3d cluster delete $(CLUSTER)

.PHONY: lint
lint:
	@kubeconform -strict \
		-schema-location default \
		-schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
		-ignore-filename-pattern '.*/values/.*' \
		-ignore-filename-pattern '(.*/)?\..+' \
		.
	@yamllint .

.PHONY: argo-password
argo-password:
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy
	@echo "copied to clipboard"
