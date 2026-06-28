.PHONY: lint
lint:
	@kubeconform -strict \
		-schema-location default \
		-schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
		-ignore-filename-pattern '.*/values/.*' \
		.

.PHONY: argo-password
argo-password:
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy
	@echo "copied to clipboard"