
#!/usr/bin/env bash

set -euo pipefail

TIMEOUT=1800

sync_wave() {
    local wave="$1"
    shift
    local apps=("$@")

    echo ""
    echo "========================================"
    echo "Starting sync wave: ${wave}"
    echo "Applications: ${apps[*]}"
    echo "========================================"

    # Start all applications in this wave
    for app in "${apps[@]}"; do
        echo "Starting: ${app}"
        argocd app sync "$app" --async
    done

    # Wait until every application is Synced and Healthy
    for app in "${apps[@]}"; do
        echo "Waiting for: ${app}"
        argocd app wait "$app" \
            --sync \
            --health \
            --timeout "$TIMEOUT"
    done

    echo "Wave ${wave} completed successfully."
}

sync_wave -6 namespaces \
   aws-load-balancer-service-account \

sync_wave -5 \
    aws-load-balancer-controller

sync_wave -4 \
    karpenter-crd

sync_wave -3 karpenter

sync_wave -2 \
    administrative \
    consul \
    external-secrets 

sync_wave -1 \
    vault \
    prometheus-kafka-exporter \
    kube-prometheus-stack \
    grafana \
    strimzi-kafka-operator \
    elastic-operator

sync_wave 0 \
    external-secrets \
    miracle6

sync_wave 1 fluent-operator

echo ""
echo "All synchronization waves completed successfully!"
