+++
title = "FAQ"
+++

## What is Tugbot?

Tugbot is an open source framework for testing microservice architecture applications.  It executes tests, collects data, and report the results.  In a microservice architecture based application, testing, correlation, and traceability of tests to services, results, failures with test and environment context are extremely complex.  Discovering patterns and trends to resolve issues quickly at the team level creates significant challenges. Tugbot is created to address these challenges. 

#### Simplify Testing in Continuous Delivery (CD) phase 

It's common practice to run tests as part of a CI build flow. There are some problems with this default approach. Here is just a small list of problems:

* It's not easy to create a realistic test environment (close to production) with underlying infrastructure and different configurations.
* Integration tests might require access to "non-exposed" services and also highly depend on infrastructure and configuration.
* Some tests takes too long to run during CI build, for example: performance/stress tests, security tests, scans, background job tests, etc. Selecting the appropriate tests for CI job is always a balance between speed and simplicity of execution and "safety net" (how many tests need to be run to feel safe).
* Microservices architecture (tens and hundreds of micro services) and Continuous Deployment (CD) creates significant [complexities](http://martinfowler.com/articles/microservice-testing/). Now every service has a separate CI pipeline for build/test/deploy and teams can achieve multiple deployments per day. Running too many tests or integration tests for each commit is a huge overhead that can become a team productivity "bottle neck".

The idea behind Continuous Testing is to execute tests that require access to underlying infrastructure including internal services that take too much time to run, or need to be run on a very specific infrastructure, inside a real Docker cluster. Such tests should be run 24x7 with test execution triggered by timer or change event (service update, host OS update, configuration change, etc.).

Tugbot is in-cluster Continuous Testing Framework for Docker based runtime environments (Continuous Delivery): Dev→Test→Stage→Prod. 


>>**_Why did you name it “Tugbot”?_**
>>_Just like a tugboat brings container ships safely and securely into port, **Tugbot** brings quality Docker containers into production at speed and scale without sacrificing quality._

## Why Tugbot?

In a recent NGINX (developer focused) [survey](https://www.nginx.com/resources/library/app-dev-survey/), the biggest challenge holding back developers is having to constantly trade-off between quality and expected speed of delivery in multiple and complex environments that lack automation tools. Tugbot extends testing into continuous deployment (CD) environments. It executes tests in response to change events or periodically, collects test results, and uploads collected results to Test Analytics service. Tugbot is intended to make continuous testing REAL by running event driven tests in the Continuous Delivery (CD) phase of the software development lifecycle.

#### Use Cases for Tugbot Framework for modern "2 pizza" development teams:

1. Simplify and standardize running ANY test (integration, component, performance, chaos, security, etc) using a standard Dockerfile — A “test container”, agnostic of the tooling. Allows for testing of complex backing services.
2. Event driven testing - Trigger test on specific events to reduce execution times by providing granularity and parellism.
  * Docker events: image update, new container, etc (supported)
  * Timer events: CRON — time interval, etc
  * Host events: kernel updates, host restart, package update, config update
  * External event: User driven, etc
3. Standardize collection of test results from all machines - Aggregating and analyzing test results over time enables traceability and correlation of tests, failures, and results with deployment event context to speed up resolution.
4. "Social Testing - By creating "test containers", these can be shared by development teams with their peers and the community. 

## How do I get Tugbot?

It’s really simple to get started. Developers can go to our github repository and download [Tugbot](https://github.com/gaia-docker/tugbot). Feedback can be provided directly to our team via our Slack channel at [tugbot.slack.com](https://tugbot.slack.com) or visit [tugbot.io](http://tugbot.io). Tugbot consists of the following core [services](https://github.com/gaia-docker):

* [Tugbot run](https://github.com/gaia-docker/tugbot)
* [Tugbot collect](https://github.com/gaia-docker/tugbot-collect)
* [Tugbot results](https://github.com/gaia-docker/tugbot-result-service)
* Docker Swarm: [Tugbot Swarm](https://github.com/gaia-docker/tugbot-leader) - This is the **Tugbot run** service for Swarm.
* Kubenertes: [Tugbot Kubernetes](https://github.com/gaia-docker/tugbot-kubernetes) - This is the **Tugbot run** service for Kubernetes.

The best way to get started quickly is by cloning our [DEMO app](https://github.com/gaia-docker/example-voting-app). 

```git clone https://github.com/gaia-docker/example-voting-app.git```

Please note the [pre-requisites and guide](https://github.com/gaia-docker/example-voting-app/blob/master/DEMO-FLOW.md) for using the DEMO app.

The DEMO app allows you to deploy in standalone, [Swarm](https://github.com/gaia-docker/tugbot-leader), or [Kubernetes](https://github.com/gaia-docker/tugbot-kubernetes) cluster environments. We also demonstrate the use of our [chaos engineering tool](https://github.com/gaia-adm/pumba) (Pumba) to simulate chaos with network delays and failures to ensure resiliency of your system. 

## How do I collaborate with you on Tugbot?

You can join our [Slack Channel](https://tugbot.slack.com/). You can also open issues on [github](https://github.com/gaia-docker). We gladly accept pull requests.

## Where do you intend to take Tugbot?

We envision community based contributions of base "test container images" in a Docker Registry. Just like Github has enabled "social coding", Tugbot promotes "social testing".  No special configuring of test packages per deployment environment. Tests can be on-demand and event driven (e.g. docker events, timer, host, etc). Results collections are standardized for tests of services owned by the teams. They can visualize them via our integrated solution ("Gaia" -- coming soon) based open source tools like ElasticSearch with Kibana. For a portfolio and enterprise view, customers can use our commercial tools like [ALM Octane](https://saas.hpe.com/en-us/software/alm-octane) (future integrations).

## How to create a Tugbot test container image?

It's very easy to create a test container. All it requires is a few lines of code in a Dockerfile ([example](https://github.com/gaia-docker/example-voting-app/blob/master/tests/Dockerfile)). We leverage the Docker and Kubenertes events API and LABELs to describe the test container that will enable Tugbot to automatically detect, run, and capture results when running in a cluster. 

## Where can I learn more?

You can go to our [github repo](https://github.com/gaia-docker/tugbot) to learn more or by reading some of our blog posts:

* [Continuous testing framework for Docker containers](https://medium.com/@GehaniNeil/continuous-testing-framework-for-docker-containers-c40325100e5c#.h9laeu1vk)
* [Is DevOps becoming the buzzword du jour?](https://medium.com/@GehaniNeil/is-devops-becoming-the-buzzword-du-jour-d76438524be0#.g8tqj72gc)
* [Pumba - Chaos Testing for Docker Containers](https://medium.com/@alexeiled/pumba-chaos-testing-for-docker-1b8815c6b61e#.ajq8nf6cc)
* [Network Emulation Chaos Testing for Docker Containers](https://medium.com/@alexeiled/network-emulation-for-docker-containers-f4d36b656cc3#.8apiih8ox)
* [Docker Pattern: Deploy and Update Dockerized Application on a cluster](https://medium.com/@alexeiled/docker-pattern-deploy-and-update-dockerized-application-on-a-cluster-d9aa141625ef#.k67614893)
* [Docker Pattern: The Build Container](https://medium.com/@alexeiled/docker-pattern-the-build-container-b0d0e86ad601#.gl07w8abn)
    *  Reddit Comment: I agree with [/u/ihsw](https://www.reddit.com/u/ihsw) -- great article, this sub needs more content like this (instead of "This One Weird Trick" junk or another wordpress tutorial). And, it's very helpful to see this concept explained clearly and succinctly. I imagine this is going to be one of those posts that I constantly google to send to people
* [Testing Strategies for Docker Containers](https://medium.com/@alexeiled/testing-strategies-for-docker-containers-f633e261e75a#.xxq0y7vig)

Join the [Tugbot community](https://tugbot-public.slack.com/) to learn more. For Developers & Contributors, please join us at this [Slack channel](https://tugbot.slack.com).