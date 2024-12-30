ProjectName="amancloud-ff723"
ClusterName="testclus"
MachineType="e2-medium" # smaller option is g1-small
NodeVersion="1.28.15-gke.1388000"
NumNodes=2
Location="asia-southeast1"

gcloud beta container --project $ProjectName clusters create $ClusterName \
  --zone "$Location-a" \
  --tier "standard" \
  --no-enable-basic-auth \
  --cluster-version $NodeVersion \
  --release-channel "None" \
  --machine-type $MachineType \
  --image-type "UBUNTU_CONTAINERD" \
  --disk-type "pd-balanced" \
  --disk-size "50" \
  --node-labels stack=app,pool=default \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes $NumNodes \
  --logging=SYSTEM,WORKLOAD \
  --monitoring=SYSTEM \
  --enable-ip-alias \
  --network "projects/$ProjectName/global/networks/default" \
  --subnetwork "projects/$ProjectName/regions/$Location/subnetworks/default" \
  --no-enable-intra-node-visibility \
  --default-max-pods-per-node "110" \
  --enable-ip-access \
  --security-posture=standard \
  --workload-vulnerability-scanning=disabled \
  --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
  --no-enable-autoupgrade \
  --no-enable-autorepair \
  --max-surge-upgrade 0 \
  --max-unavailable-upgrade 1 \
  --binauthz-evaluation-mode=DISABLED \
  --enable-managed-prometheus \
  --enable-shielded-nodes \
  --node-locations "$Location-a"

gcloud beta container --project $ProjectName node-pools create "second-pool" \
  --cluster $ClusterName \
  --zone "$Location-a" \
  --node-version $NodeVersion \
  --machine-type $MachineType \
  --image-type "UBUNTU_CONTAINERD" \
  --disk-type "pd-balanced" \
  --disk-size "50" \
  --node-labels stack=app,pool=second \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes $NumNodes \
  --no-enable-autoupgrade \
  --no-enable-autorepair \
  --max-surge-upgrade 0 \
  --max-unavailable-upgrade 1 \
  --node-locations "$Location-a"