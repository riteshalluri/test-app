AWS_ACCOUNTID="1234567890"
AWS_REGION="ap-southeast-2"
AWS_ECRREPO="ECR_REPO_NAME"

## Deploy EKS cluster in AWS
cd terraform-eks-clusters

## Initialise terraform module
terraforn init

## create EKS cluster
terraform apply

## update kubeconfig file with newly created cluster info
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

cd ../App

#get SHA value of the python application
shm_id=$(sha256sum app.py | awk '{print $1}')

#replace the SHA varaible value in app.py with $shm_id value
sed -i -e 's/AppSHAValue/$shm_id/g' app.py

## Build app Image
docker build -t appImage .

## Push image to ECR
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin $AWS_ACCOUNTID.dkr.ecr.region.amazonaws.com
docker tag backend $AWS_ACCOUNTID.dkr.ecr.region.amazonaws.com/$AWS_ECRREPO:tag
docker push $AWS_ACCOUNTID.dkr.ecr.region.amazonaws.com/$AWS_ECRREPO:tag

## Deploy postgres DB using DB deployment file in new cluster
cd ../K8-Deployment

## Deploy app for dev
kubectl apply -k overlays/dev

##
## ONce the app deployed the service should be accessible fro http://localhost:32000





