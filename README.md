# DevSecOps-Demo
This repository is used as an open source demonstration of Moonrake's DevSecOps capabilities. This is a continuous work in progress and subject to change daily.

## Issue Tracking
Issues can be tracked in the [issues tab](https://github.com/MoonrakeOpen/DevSecOps-Demo/issues) in this GitHub repository. We have an internal repository for most of our work but we have found the features of GitHub to be easier for this open source project since the project is already made public. You can take a look at upcoming tasks and features in the [projects](https://github.com/MoonrakeOpen/DevSecOps-Demo/projects) section. of the repository.

## Git Strategy
We are using a combination of the forking strategy which is common among open-source projects in combination with the GitFlow workflow.

## Git Strategy Diagram
![gitflow diagram](https://miro.medium.com/max/2432/1*RdfreU6QIY6fyBNTITwzSw.png)

## Project Structure
The goal of this project is to have sub-directory broken down into the components of our DevSecOps vision. There are many improvements to be made and we are sorting these out one day at at time. Each sub-directory will hold it's own documentation to prevent this readme from getting to convoluted. 

### Docker Containers
The most critical component are the docker configurations. Each docker file is hardened to DoD's standards. These docker "projects" will be submitted to the DoD to be imported and approved in their DevSecOps factory.

### Kube 
This is the section that holds our Kubernetes (k8s) demo's. This currently holds a submodule of a project we build to be deployed to google cloud through TravisCI you can view the repo [here](https://github.com/kaiprt/k8s-demo) and the TravisCI project [here](https://travis-ci.org/kaiprt/k8s-demo).

#### K8S Security
We are actively integrating Istio (sidecar service mesh) into our demonstrations. The goal is to replace a single piece of functionality per day with an Istio equivalent.
