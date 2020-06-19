resource "null_resource" "project_dependency_update" {
  depends_on = [
    module.eks,
    null_resource.kubectl_update,
    kubernetes_secret.main,
  ]

  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "helm dep up helm_charts/rshiny-eks"
  }
}

resource "null_resource" "project_upgrade" {
  depends_on = [
    null_resource.kubectl_update,
    null_resource.project_dependency_update,
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    helm upgrade --install rshiny helm_charts/rshiny-eks  \
        --set image.repository="jerowe/polished-tech" \
        --set image.tag=latest \
        --wait
    EOF
  }
}

resource "null_resource" "project_expose_ip" {
  depends_on = [
    null_resource.kubectl_update,
    null_resource.project_dependency_update,
    null_resource.project_upgrade,
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    sleep 60
    export EXPOSED_URL=$(kubectl get svc --namespace default rshiny-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[]?.hostname')
    helm upgrade --install rshiny helm_charts/rshiny-eks  \
        --set image.repository="jerowe/polished-tech" \
        --set image.tag=latest \
        --set ingress.hosts[0].host=$EXPOSED_URL \
        --set ingress.hosts[0].paths[0]="/" \
        --wait
    EOF
  }
}


output "helm-install-command" {
  depends_on = [
    null_resource.project_expose_ip
  ]
  value = <<EOF
    export EXPOSED_URL=$(kubectl get svc --namespace default rshiny-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[]?.hostname')
    helm upgrade --install rshiny helm_charts/rshiny-eks  \
        --set image.repository="jerowe/polished-tech" \
        --set image.tag=latest \
        --set ingress.hosts[0].host=$EXPOSED_URL \
        --set ingress.hosts[0].paths="/" \
        --wait
    EOF
}

output "rshiny-ip" {
  depends_on = [
    null_resource.project_expose_ip
  ]
  value = <<EOF
    export EXPOSED_URL=$(kubectl get svc --namespace default rshiny-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[]?.hostname')
    echo $EXPOSED_URL
    EOF
}
