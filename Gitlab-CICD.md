# Git Lab CI-CD
## 1. Introduction
## 2. overview and concepts
* SDLC(software development life cycle)
* plan -> implement -> test -> deploy -> maintain
* operation team make sure no downtime, handle huge traffic
## 3. Git Lab
* host the application code
* version control with git based repositories
* team collaborate on the code
* merge request, code reviews, file locking, granular access control
* CI/CD platform
## 4. GitLab compare to other CI/CD platforms
* jenkins is old tool, which was not designed for the new container age
* GitLab has many features built-in: self-monitoring, container registry, docker ci runner , ....
* GitLab is same tool for managing code and CI/CD
* Gitlab is both selfhosted and SaaS(commercial)
* jenkins is selfhosted and azure pipeline is saas(good for microsoft integration)
## 5. How to configure a gitlab ci/cd
* merge code changes -> remote git repository -> test -> build docker image -> push to docker registery
* whole logic is scripted in YAML format i.e **.gitlab-ci.yml**
* gitlab-ci.yml
## 6. Building logic in yml file
* **jobs** --> jobs are most fundamental building block of a .gitlab-ci.yml, basic building bock of pipelines eg:run_test
* **script:** --> commands to execute, we can have list of command
* **before_script:** --> help to set up env variables, anything has to be done before execution of script, etc
* **after_script:** --> anything has to be done after execution of script
```yml

run_tests:
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."
```
## 7. Execution in gitlab platform
* [Link to project](https://gitlab.com/nanuchi/mynodeapp-cicd-project)
* Fork the project and select the namespace
* create a file with .<filename>.yml in main folder for pipeline
* paste the pipeline script and commit it.
* when we do commit the gitlab executes the pipeline once for validation and checks for errors
* we can see ci/cd background process in repository --> CI/CD -->pipelines
* to edit pipeline logic we can go directly repository --> CI/CD --> editor
