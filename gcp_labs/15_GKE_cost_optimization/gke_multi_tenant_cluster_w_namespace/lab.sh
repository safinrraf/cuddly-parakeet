#In this lab you will learn how to set up a multi-tenant cluster using multiple namespaces to optimize resource utilization and, in effect, optimize costs.

gcloud config set project qwiklabs-gcp-00-1002b19c93c7

#Run the following to set a default compute zone and authenticate the provided cluster multi-tenant-cluster:
export ZONE=us-east1-d
gcloud config set compute/zone ${ZONE} && gcloud container clusters get-credentials multi-tenant-cluster

#You can get a full list of the current cluster's namespaces with
kubectl get namespace

#Important note:
#Not everything belongs to a namespace. 
#For example, nodes, persistent volumes, and namespaces themselves do not belong to a namespace.

#For a complete list of namespaced resources
kubectl api-resources --namespaced=true -o name | wc -l
#For a complete list of non-namespaced resources
kubectl api-resources --namespaced=false -o name | wc -l
#For a complete list of all resources
kubectl api-resources -o name | wc -l
#For a complete list of all resources with their namespaced status
kubectl api-resources -o name --namespaced=true

#You can also get a list of all the resources in the kube-system namespace with
#This is a system namespace that contains resources that are not namespaced.
#For example, the kube-dns service is not namespaced.
#You can see that the kube-dns service is not namespaced by running the following command:
kubectl get services --namespace=kube-system


#Creating new namespaces
#Note: When creating additional namespaces, avoid prefixing the names with ‘kube' as this is reserved for system namespaces.

#Create 2 namespaces for team-a and team-b
kubectl create namespace team-a
kubectl create namespace team-b

#As an example, run the following to deploy a pod in the team-a namespace and in the team-b namespace using the same name
kubectl run app-server --image=centos --namespace=team-a -- sleep infinity && \
kubectl run app-server --image=centos --namespace=team-b -- sleep infinity

#You can see that the pods are running in the team-a and team-b namespaces with the following command:
kubectl get pods --namespace=team-a
kubectl get pods --namespace=team-b
#You can also see that the pods are running in the team-a and team-b namespaces with the following command:
kubectl get pods --all-namespaces

#Use kubectl describe to see additional details for each of the newly created pods by specifying the namespace with the --namespace tag
kubectl describe pod app-server --namespace=team-a
kubectl describe pod app-server --namespace=team-b


#Grant the account the Kubernetes Engine Cluster Viewer role by running the following
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:team-a-developers@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com  \
--role=roles/container.clusterViewer

#to list the rolebindings in the team-a namespace, run the following command:
kubectl get rolebindings --namespace=team-a

#Roles with single rules can be created with kubectl create
kubectl create role pod-reader \
--resource=pods --verb=watch --verb=get --verb=list \
--namespace=team-a

#to delete rolebinding, run the following command:
kubectl delete rolebinding pod-reader

#To delete the role, run the following command:
kubectl delete role pod-reader

#Apply the role above
kubectl create -f developer-role.yaml

#Create a role binding between the team-a-developers serviceaccount and the developer-role
kubectl create rolebinding team-a-developers --role=developer --user=team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --namespace=team-a

#Download the service account keys used to impersonate the service account
gcloud iam service-accounts keys create /tmp/key.json --iam-account team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com



#Run the following to enable GKE usage metering on the cluster and specify the dataset cluster_dataset
export ZONE=placeholder
gcloud container clusters \
  update multi-tenant-cluster --zone ${ZONE} \
  --resource-usage-bigquery-dataset cluster_dataset