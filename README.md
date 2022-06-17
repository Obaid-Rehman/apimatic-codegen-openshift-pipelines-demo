# APIMatic CodeGen OpenShift Pipelines Demo

APIMatic CodeGen is your go-to cloud-ready provider for making the customer on-boarding experience of your APIs a seamless experience. With a flexible set of inputs in the form of an API Portal Build configuration file along with the associated API specification file, logo images and optional custom content, the APIMatic CodeGen app outputs DX Portal artifacts, including SDKs and Docs, that can be deployed in your environment of choice. [OpenShift Pipelines](https://cloud.redhat.com/blog/introducing-openshift-pipelines) is a CI/CD solution for building pipelines using [Tekton](https://tekton.dev). 

Following the steps given in this demo, you will see that by using the OpenShift Pipelines operator together with the RedHat-certified [APIMatic CodeGen Operator](https://github.com/apimatic/apimatic-codegen-operator), a complete automation flow can be devised to take your API Portal configurations from source to production-ready DX portal deployment a painless task. You can even use this demo as a starter project to devise your own Source-to-API DX Portal automation flow design without much hassle.

## Project Info

If you would like to know more about how this project is set up and what the different directories and files are for, you can find that information [here](./docs/demo_structure.md). You can view that information later as it is not necessary to understand it to proceed with the demonstration.

## Prerequisites

You need an OpenShift 4 cluster to follow the steps given in this demonstration. If you don't have an existing cluster, go to http://try.openshift.com and register for free in order to get an OpenShift 4 cluster up and running on AWS within minutes.

## Demonstration

With your OpenShift 4 cluster setup, we can now proceed with the demonstration using the steps given below:

- Fork This Repo

  Fork this repository and add the values for the Repo secrets that will be used to run the initial OpenShift assets set up. These include:

  - #APIMATICLICENSEBLOB#: 


