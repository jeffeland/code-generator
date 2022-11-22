{{- if and .Values.aws.irsa.accountID .Values.aws.irsa.oidcProvider }}
apiVersion: iam.services.k8s.aws/v1alpha1
kind: Role
metadata:
  name: {{ .Values.serviceAccount.name }}
  namespace: {{ .Release.Namespace }}
spec:
  description: IRSA role for ACK {{ .ServicePackageName }} controller deployment on EKS cluster using Helm charts
  name: {{ .Values.serviceAccount.name }}
  policies:
    - "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  assumeRolePolicyDocument: >
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "arn:aws:iam::{{ .Values.aws.irsa.accountID }}:oidc-provider/{{ .Values.aws.irsa.oidcProvider }}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringEquals": {
              "{{ .Values.aws.irsa.oidcProvider }}:sub": "system:serviceaccount:{{ .Release.Namespace }}:{{ .Values.serviceAccount.name }}"
            }
          }
        }
      ]
    }
{{- end }}