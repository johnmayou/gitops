# gitops

ArgoCD app-of-apps for a local k3s cluster. k3d runs k3s in Docker Desktop.

`make up` creates the cluster, installs ArgoCD with Helm, and applies the root app in `apps.yaml`. Argo then pulls everything else from `main` in this repo.

## Usage

Tools come from mise. Run `mise install` once.

| Command     | What it does                                                         |
| ----------- | -------------------------------------------------------------------- |
| `make up`   | Create cluster `local` (kube context `k3d-local`) and install ArgoCD. |
| `make down` | Delete the cluster.                                                  |
| `make lint` | Validate manifests with kubeconform and yamllint.                    |

`make up` is safe to run again. It skips cluster creation if the cluster exists.

## URLs

Everything is plain HTTP on port 80.

| URL                                   | What                              |
| ------------------------------------- | --------------------------------- |
| `http://argocd.localhost`             | ArgoCD UI. Log in as `admin`/`admin`. |
| `http://<ui>.localhost`               | Other cluster UIs, at their root path. |
| `http://api.localhost/<service>`      | Service APIs. Traefik strips the `/<service>` prefix. |

## Layout

- `apps.yaml`: the root Application. It syncs `apps/`.
- `apps/`: one Application per group of workloads.
- `argocd/values.yaml`: Helm values for ArgoCD. `make up` installs ArgoCD, so Argo does not manage itself.
- `monitoring/`: Prometheus, Grafana, and Loki.
