# APIMatic CodeGen OpenShift Pipelines Demo

APIMatic CodeGen is your go-to cloud-ready provider for making the customer on-boarding experience of your APIs a seamless experience. With a flexible set of inputs in the form of an API Portal Build configuration file along with the associated API specification file, logo images and optional custom content, the APIMatic CodeGen app outputs DX Portal artifacts, including SDKs and Docs, that can be deployed in your environment of choice. [OpenShift Pipelines](https://cloud.redhat.com/blog/introducing-openshift-pipelines) is a CI/CD solution for building pipelines using [Tekton](https://tekton.dev). 

Following the steps given in this demo, you will see that by using the OpenShift Pipelines operator together with the RedHat-certified [APIMatic CodeGen Operator](https://github.com/apimatic/apimatic-codegen-operator), a complete automation flow can be devised to take your API Portal configurations from source to production-ready DX portal deployment a painless task. You can even use this demo as a starter project to devise your own Source-to-API DX Portal automation flow design without much hassle.

## Project Directory Structure

    .
    ├── build                   # Compiled files (alternatively `dist`)
    ├── docs                    # Documentation files (alternatively `doc`)
    ├── Portal                  # Contains the actual files used to configure the generated API DX Portal  
    │   ├── content
    │   │   ├── about.md 
    │   │   ├── readme.md
    │   │   └── toc.yml
    │   ├── spec
    │   │   └── spec1
    │   │       └── openapi.json     # The API Spec file from which the API SDKs and Docs will be generated
    │   ├── static
    │   │   └── images
    │   │       └── logo.png   
    │   └── APIMATIC-BUILD.json      # The main APIMatic CodeGen build file that is read by APIMatic CodeGen to process the associated
    │                                # artifacts and produce the desired SDKs, Docs and API Specs
    ├── k8s                          # K8s yaml files used to set up the DX portal Service, Deployment and OpenShift Route resources
    │    ├── deployment.yaml 
    │    ├── route.yaml
    │    └── service.yaml      
    ├── setup                   
    │    ├── codegen.yaml             # K8s APIMatic CodeGen custom resource yaml file
    │    └── operatorassets.yaml      # Yaml file containing the OpenShift Pipelines and 
    │                                 # APIMatic CodeGen Operator installation info
    ├── LICENSE
    └── README.md
    └── Dockerfile                   # Dockerfile used to containerize and run the DX portal web server 
                                     # using the Portal artifacts generated using APIMatic CodeGen

## Prerequisites

You need an OpenShift 4 cluster to follow the steps given in this demonstration. If you don't have an existing cluster, go to http://try.openshift.com and register for free in order to get an OpenShift 4 cluster up and running on AWS within minutes.


