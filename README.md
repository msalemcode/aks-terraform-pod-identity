# aks-terraform-pod-identity

Today as we develop and run application in AKS, we do not want credentials like database connection strings, keys, or secrets and certificates exposed to the outside world where an attacker could take advantage of those secrets for malicious purposes. Our application should be designed to protect customer data. AKS documentation describes in detail security best practice here https://docs.microsoft.com/en-us/azure/aks/developer-best-practices-pod-security
