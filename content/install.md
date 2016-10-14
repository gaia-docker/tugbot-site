+++
title = "Install ME"
+++


## Download and Install

Pre-Requisites:

1. [Docker for Mac v1.12 or higher](https://docs.docker.com/docker-for-mac/)
2. [Docker for Windows v1.12 or higher](https://docs.docker.com/docker-for-windows/)
3. [Docker for Linux environments](https://docs.docker.com/engine/installation/linux/#/install-docker-engine-on-linux)
4. Familar with [Unix CLI](https://en.wikipedia.org/wiki/List_of_Unix_commands) ([macOS](http://ss64.com/osx/)) or [Window Powershell](https://msdn.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/using-familiar-command-names)

* Tugbot in your environment
* Tugbot with the Example Voting App

## Standalone

See Pre-Requisites

Example Voting App DEMO

1. Go to the [gaia-docker/example-voting-app](https://github.com/gaia-docker/example-voting-app) repo
2. Copy the URL by clicking on the Clone or Download
3. Run ```git clone https://github.com/gaia-docker/example-voting-app.git```
4. ```cd example-voting-app/```
5. Follow the instructions in the [DEMO_FLOW.md](https://github.com/gaia-docker/example-voting-app/blob/master/DEMO-FLOW.md) file to run the demo scripts in the following order:

   1. run ```./1_deploy.sh``` - This deploys the voting app. The first time, it will automatically pull the relevant Docker images. It consists of 5 services. You can check that the 5 services are running by doing a ```docker ps```. You should see 5 services running.
   2. run ```./2_deploy_tugbot.sh``` - This deploys 5 additional services. 3 Tugbot services (Run, Collect, Results) and 2 additional services (ElasticSearch and Kibana). The first time, it will automatically pull the relevant Docker images. Running ```docker ps`` should show 10 services running. 
   3. run ```./3_configure_kibana.sh``` to setup ElasticSearch and Kibana
   4. run ```./4_run_tests.sh``` to run tugbot. Please note the 1st run needs to be triggered. Normally, this would be executed by an orchestration engine like Swarm, Kubernetes, or Mesos-Marathon.
   5. run ```./5_bug_on_off.sh``` to introduce failures by deploying bad and good code. You can pass a parameter on the command like ```./5.bug_on_off 3``` to run 3 iterations.
   6. run ```./7_pumba.sh``` to introduce chaos in the system
   7. run ```./8_tugbot_clean.sh``` to cleanup by removing pumba, tests, and Tugbot
   8. run ```./9_clean.sh``` to remove volume and networks. The volumes will remain in the filesystem. The ```all``` parameter will also delete the volumes.  

## Swarm


## Kubernetes

