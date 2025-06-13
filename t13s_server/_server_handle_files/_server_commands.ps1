

REGISTRY_DOMAIN
REGISTRY_USER
REGISTRY_PASSWORD
REGISTRY_EMAIL
REDIS_PASSWORD
DB_PASSWORD
SERVICE_SECRET
KUBE_CONFIG

# serverpod
docker compose up -d
serverpod create-migration --experimental-features=all
serverpod generate --experimental-features=all
dart bin/main.dart --apply-migrations

docker compose down -v

#kubernaties
# 1. Установить nginx ingress
# 2. Установить дополнение cert-manager
# Секрет для Docker Registry
kubectl apply -f k8s_1/

# проброс порта для бд
Start-Job -ScriptBlock { kubectl port-forward pod/pg-proxy-pod 54321:5432 }
kubectl port-forward pod/pg-proxy-pod 54321:5432


[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('пароль'))

# Проверим поды
kubectl get pods
kubectl get pods -w

# Проверим сервисы
kubectl get svc
kubectl get svc t13s-server-service -o yaml 

# логи приложения
kubectl logs -f -l app=t13s-server

#kubectl logs serverpod-migration-job-ts3-6llg9

# Тестируем endpoint для получения списка TestData
Invoke-WebRequest -Uri "https://api5.my-points.ru/" -Method POST -ContentType "application/json" -Body '{"endpoint":"testData","method":"listTestDatas","params":{}}'

# Проверка доступности напрямую
Invoke-WebRequest -Uri "https://api5.my-points.ru/" -Method GET

# Проверим детали Ingress:
bashkubectl describe ingress sync2-server-ingress

docker login dbe81550-wise-chickadee.registry.twcstorage.ru
docker build -t dbe81550-wise-chickadee.registry.twcstorage.ru/t13s-server:latest -f Dockerfile.prod .
docker push dbe81550-wise-chickadee.registry.twcstorage.ru/t13s-server:latest

kubectl apply -f k8s/

kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/job.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/secret.yaml


#delete project
kubectl delete -f k8s/

kubectl delete service t13s-server-service
kubectl delete ingress t13s-server-ingress
kubectl delete configmap serverpod-config-t13s
kubectl delete job serverpod-migration-job-t13s
kubectl delete secret serverpod-secrets-t13s
kubectl delete deployment t13s-server-deployment

#restart deployment
kubectl rollout restart deployment t13s-server-deployment




