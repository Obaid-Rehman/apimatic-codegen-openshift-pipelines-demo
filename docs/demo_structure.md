# Project Directory Structure

    .
    ├── .github
    │   └── workflows
    │       ├── main.yaml
    │       └── setup_openshift_infrastructure.yaml
    │
    ├── .tekton
    │   ├── apply-manifest-task.yaml 
    │   ├── get-portal-zip.yaml
    │   ├── persistent_volume_claim.yaml
    │   ├── pipeline.yaml 
    │   ├── update-deployment-task.yaml
    │   └── zip-build-folder-task.yaml
    │
    ├── Portal                       # Contains the actual files used to configure the generated API DX Portal  
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
    │
    ├── docs                         # This directory
    │   ├── demo_structure.md        # This file
    │   └── ...                      # images etc.
    │
    ├── k8s                          # K8s yaml files used to set up the DX portal Service, Deployment and OpenShift Route resources
    │   ├── deployment.yaml 
    │   ├── route.yaml
    │   └── service.yaml 
    │
    ├── setup                   
    │    ├── codegen.yaml             # K8s APIMatic CodeGen custom resource yaml file
    │    └── operatorassets.yaml      # Yaml file containing the OpenShift Pipelines and 
    │                                 # APIMatic CodeGen Operator installation info
    │
    ├── LICENSE
    └── README.md
    └── Dockerfile                    # Dockerfile used to containerize and run the DX portal web server 
                                      # using the Portal artifacts generated using APIMatic CodeGen
