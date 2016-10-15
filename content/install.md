+++
title = "Install ME"
+++


## Download and Install

Pre-Requisites:

1. [Docker for Mac v1.12 or higher](https://docs.docker.com/docker-for-mac/)
   1. Bash shell
2. [Docker for Windows v1.12 or higher](https://docs.docker.com/docker-for-windows/)
3. [Docker for Linux environments](https://docs.docker.com/engine/installation/linux/#/install-docker-engine-on-linux)
4. Familar with [Unix CLI](https://en.wikipedia.org/wiki/List_of_Unix_commands) ([macOS](http://ss64.com/osx/)) or [Window Powershell](https://msdn.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/using-familiar-command-names)

## Tugbot in your environment

Download Tugbot to run in your own cluster. Tugbot consists of 3 services:

1. [Tugbot Run](https://github.com/gaia-docker/tugbot)
2. [Tugbot Collect](https://github.com/gaia-docker/tugbot-collect)
3. [Tugbot Results Service API](https://github.com/gaia-docker/tugbot-result-service)

## Example - DockerCon 2016 Voting App with Tugbot

### Standalone

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

### Swarm

See Pre-Requisites

Follow the instructions in the [DEMO-FLOW-SWARM.md](https://github.com/gaia-docker/example-voting-app/edit/master/DEMO-FLOW-SWARM.md)

1. From the cloned directory - ```cd swarm```
  1. run ```./0_swarm_cluster_mac.sh``` (macOS)- This will create a new Swarm cluster on localhost. To control the number of worker nodes, use the `NUM_WORKERS` environment variable. 
   **Note:** in case of failure try to run this script once again.
  2. To see your Swarm cluster, open [Swarm Visualizer](http://localhost:8000). You will need to download the [ManoMarks visualizer](https://github.com/ManoMarks/docker-swarm-visualizer)
  3. The voting app will run at `http://localhost:<x>5000`
  4. The results app will run at `http://localhost:<x>5001`

   * where `x` represent worker index: 1,2,3... (check Swarm Visuzalizer for right index)  
   
2. Deploy Voting application:

    Run ```./1_deploy.sh```

3. Deploy Tugbot Testing Framework:

    Run ```./2_deploy_tugbot.sh``` - The following Docker services will run: `es`, `kibana, ``tugbot-leader`, `tugbot-run`, `tugbot-collect` and `tugbot-result-service-es`.

4. Import Dashboard Setting Into Kibana:

    Run ```./3_configure_kibana.sh```
    
   * Kibana dashboard is now accessible at `http://localhost:<x>5601`. **NOTE:** The UI is still not usable until `tugbot` sends at least 1 result to Elasticsearch.  

5. Execute Integration and Functional Tests:

    Run ```./4_run_tests.sh```

  * **Expected:** ALL test must pass now. You should see now the test results in Kibana Dashboard  

6. Modify Application by injecting and fixing failures:

    Run ```./5_bug_on_off.sh```

  * **NOTE:** This script will re ```./1_deploy.sh``` with  **bad** and **good** version of Vote app  

7. Fix Application:

    Run ```./1_deploy.sh```

  * **Expected:** We returned the "Good" image, hence - All tests should pass now. You should see now the test results in Kibana Dashboard at [http://localhost:5601](http://localhost:5601)  

8. Simulate network chaos: Run Pumba (as "interactive" Docker container) to introduce 3 seconds delay for all egress traffic from `result-app` container. Network emulation is activated every minute and lasts for 30 seconds only, after that connection is restored to work normally.

    Run ```./7_run_pumba.sh``` - Use Ctrl-C to stop Pumba

   * **Expected**: some test might fail now, but should pass, once network emulation stopped.  

9. Clean up Tugbot only:

    Run ```./8_clean_tugbot.sh```

10. Clean up Tugbot and the voting app:

    Run ```./9_clean.sh```

11. To destroy local Swarm cluster:

    Run ```./9_x_clean_swarm_mac.sh```(macOS)

**NOTE:** The scripts above will leave the volume on the docker host that is used by ElasticSearch. 

You can verify the volume's existence by running: ```docker volume ls```. To remove the volume, run ```docker volume rm``` *volume name*.


### Kubernetes

#### Coming soon...

