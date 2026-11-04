# miracle6-k8s
k8s manifests

## Administrative Helm chart

The `administrative/` directory is a Helm chart containing the GP3 StorageClass,
Karpenter NodePool and EC2NodeClass, and the AWS load balancer controller and
EBS CSI driver ServiceAccounts. The chart has no `values.yaml`; all five
environment-specific values must be supplied at installation:

```sh
helm upgrade --install administrative ./administrative --namespace kube-system \
  --set kmsKeyId="${kms_key_id}" \
  --set karpenterNodeRole="${karpenter_node_role_name}" \
  --set clusterName="${cluster_name}" \
  --set loadBalancerRoleArn="${alb_role_arn}" \
  --set ebsCsiDriverRoleArn="${ebs_driver_role_arn}"
```
