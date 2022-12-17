# Kubernetes Autoscaling

Horizontal vs. Vertical Scaling

|      	| Horizontal            	| Vertical                                                	|
|------	|-----------------------	|---------------------------------------------------------	|
| Pod  	| Adds or removes Pods  	| Modifies CPU and/or RAM resources allocated to the Pod  	|
| Node 	| Adds or removes Nodes 	| Modifies CPU and/or RAM resources allocated to the Node 	|

## Horizontal Pod Autoscaling (HPA)

HPA allows us to scale pods when their resource utilisation goes over a threshold. We need a simple app, that generates some CPU load and use aimvector/application-cpu:v1.0.0 from dockerhub for this.

Configure resource requirements in deployment.yaml:

```bash
resources:
  requests:
    memory: "50Mi"
    cpu: "500m"
  limits:
    memory: "500Mi"
    cpu: "2000m"
```
The settings here depend on the size of your VM (1 CPU core=1000m).

Deploy the images:
```bash
kubectl apply -f deployment.yaml
```

Get metrics:
```bash
kubectl top pods
```

## Cluster Autoscaler

For cluster autoscaling, you should be able to scale the pods manually and watch how the cluster scales.

For traffic generation, we will use [wrk](https://github.com/wg/wrk) in the pod. Let's deploy a traffic generator pod:

```bash
kubectl apply -f traffic-generator.yaml

# get a terminal to the traffic-generator
kubectl exec -it traffic-generator sh

# install wrk
apk add --no-cache wrk

# simulate some load
wrk -c 5 -t 5 -d 99999 -H "Connection: Close" http://application-cpu

# you can scale to pods manually and see roughly 3-4 pods will satisfy resource requests.
kubectl scale deploy/application-cpu --replicas X
```

Deploy an autoscaler

```bash
# scale the deployment back down to 2
kubectl scale deploy/application-cpu --replicas 2

# deploy the autoscaler
kubectl autoscale deploy/application-cpu --cpu-percent=95 --min=1 --max=10

# pods should scale to roughly 3-4 to match criteria of 95% of resource requests
kubectl get pods
kubectl top pods
kubectl get hpa/application-cpu  -owide

kubectl describe hpa/application-cpu
```

Now we configured Kubernetes to scale automatically up (or down) when the load increases (or decreases).


References:
https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/autoscaling
https://www.youtube.com/watch?v=jM36M39MA3I
https://www.youtube.com/watch?v=FfDI08sgrYY
