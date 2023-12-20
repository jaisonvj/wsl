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
* we can see ci/cd background process in CI/CD -->pipelines
* to edit pipeline logic we can go directly CI/CD --> editor
## 8. Stage in gitlab ci/cd
* to run in order not parallel we use stages
* if one job fails , next stage not work, but next job works in parallel
* here we can group multiple jobs under single stage
* .gitlab-ci.yml
```yml
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 9. Relationship in the jobs i.e job dependency("needs")
* We needed to execute jobs in a certain order within a stage
* if it fails, it should skip the other dependent jobs
* .gitlab-ci.yml
```yml
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  stage: build
  needs:
    - build_image
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 10. Script command to execute
* inline command means os command like pwd, ls, mkdir test-data
* jobs are executed on linux machine
* for more complex script we can add bash script created in main directory eg:prepare-test.sh
* everytime pipeline run in a fresh new environment, so we not needed to worry about cleanup
* .gitlab-ci.yml
```yml
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
    - pwd
    - ls
    - mkdir test-data
    - ls
    - chmod +x prepare-test.sh
    - ./prepare-test.sh
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."
    - rm -r test-data
    - ls
```
## 11. "only" specify when job should run
* create a new branch(repository --> branches) from main branch i.e feature/test-cicd-pipeline
* if we go to pipielines immediatley the pipeline is triggered for new branch by default
* we don't want to release new app version from feature or bugfuxes branches
* we only needed to test, but not build and deploy
* only -- define when a job runs
* except -- define when a job does not run
```yml
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  only:
    - main
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  only:
    - main
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  only:
    - main
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 12. "Workflow" Rules
* we dont want to run pipeline other then main branch, so we declare globally
* a global keyword, which configure the whole pipelines behavior
* environment variables -- every pipeline gitlab provides predefined variable.
* list of predefined variables in gitlab docs available
* $CI_COMMIT_BRANCH --> env for branch name
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 13. Trigger pipeline on merge request
* when feature branch is completed, the developer raises the merge request for main branch
* when it is approved whole test should run 
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  only:
    - main
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  only:
    - main
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  only:
    - main
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 14. Predefined Environment variables
* [Click here](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)
## 15. Define Project CI/CD Variables
* if we want to run pipeline for every microservices , value is passed in on pipeline execution, instead of hardcoding in .gitlab-ci.yml file.
* making the config file more re-usable and flexible.
**pre defined variable**
* variable for ci/cd is defined in settings --> CI/CD --> add variable -->
    key: MICRO_SERVICE_NAME
    valaue: shopping-cart
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data for micro service $MICRO_SERVICE_NAME..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."
```
**File type variable**
* let us consider we have properties or config file have sensetive information
* variable for ci/cd is defined in settings --> CI/CD --> add variable -->
    key: PROPERTIES_FILE
    valaue: content of file
    type: file
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data for micro service $MICRO_SERVICE_NAME..." # prints file path 
    - echo "using configuration file - $PROPERTIES_FILE .."
    - cat $PROPERTIES_FILE 
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."
```
**Defining variable in .gitlab-ci.yml file**
* if we define a variable in a job and only that job can use it
* if we define variable at top level of the file globally available and all jobs can use it
* variables saved in the file directly should store only non-sensitive data
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy

variables:
    image_repository: docker.io/my-docker-id/myapp
    image_tag: v1.0

run_unit_tests:
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:
  variables:
    image_repository: docker.io/my-docker-id/myapp
    image_tag: v1.0
  only:
    - main
  stage: build
  script:
    - echo "Building the docker image '.."
    - echo "tagging the docker image $image_repository:image_tag."

push_image:
  only:
    - main
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  only:
    - main
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 16. GitLab architecture
* GitLab server is the main componet for pipeline configuration, pipline execution, store the pipeline results
* GitLab runners are the agents that run our CI/CD jobs
* runners can be self managed or runners provided my gitlab
* GitLab Runners are program that you should install on a machine, that's separate from the one that hosts the gitlab instance.
* The provided runners by GitLab are shared runners
* shared runners are available to all projects in a GitLab instance
* shared runners on gitlab.com are available to all users on the platform
## 17. Executors
* Executor determines the environment each job runs in
  
* **Shell Executor** where commands are executed on os, which is simplest executor
* on the shell of server GitLab Runner is installed
* all required programs for executing the jobs, needed to to be installed manually
* if we want to run the docker command, docker needs to be installed first
* we neede to install, configure and update tools in server which is lot of manual work
* no clean build env
* **Docker executor** which execute jobs inside of docker container instead of shell
* for every job new container is created
* because of isolation no version conflict, we have clean state
* here docker needed to be installed
* **virtual machine** it take longer time, but we have isolated env
* **k8s executors** if we have properly configured cluster, the job is executed in pods
* **Docker Machine Executor** it is special version of docker executor
* supports auto-scaling
* lets you create hosts on your computer, on cloud provided on demand, dynamically
* creates servers, installs docker on them and configures the client to talk to them
* docker machine executor works like normal docker executor
* **GitLabs shared runners** are using docker machine executors
* **Note**: Docker machine executor has been depricated by docker !
* 2 more executor are ssh executor and parallel executor not imp
* **which executor to choose ?**
* Docker executor is best for linux os
* specific use cases we can use shell executor
![image1](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20100512.png)
![image2](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20103203.png)
* each executor needed to be register with seperate runner to use it in single ec2 instance
## 18. Architecture recap and execution flow
![image3](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20104100.png)
## 19. Docker executor
setting --> ci/cd --> runners
* shared runners -- available to all groups and projects in gitlab instance
* Group runners -- available to all projects in a group
* specific runners -- associated with a specific project
* by default the executor is docker+machine with image ruby
* we can change image by adding the image tag globally or for specific job
* lets us consider our runner doesnot have docker installed in this case docker image tag is ignored and jobs executed shell executor
```yml
image: alpine:3.18.4

workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  image: node:17-alpine
  stage: test
  before_script:
    - echo "preparing test data ..."
    - npm version
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

```
## 20. Specific runner
* for security, jobs with specific requirements, projects with lot of ci activity
* Specific runners are project specific
* Specific runners must be enabled for each project specifically
* Specific runner are self managed
* 1) set up machine 2) install gitLab runner program 3) connect to GitLab instance
* gitlab runner can installed in local machine, cloud, vm and any os
* Registering = Binding the runner to specific GitLab instance and setting connection b/w 2
## 21. Runner configuration demo
* Configuring a local runner (runner on your machine)
* configure in windows
* configure in macos
* configure in aws ec2 instance with ubuntu installed in it
## 22. Install and configure a local gitlab runner for macos
[Click here](https://docs.gitlab.com/runner/configuration/macos_setup.html)
[brew install](https://brew.sh/)
## 23. Install and configure a local gitlab runner for windows
[Click here](https://docs.gitlab.com/runner/install/windows.html)
1. create a folder C:\GitLab-Runner
2. download binary
3. copy download to C:\GitLab-Runner and rename gitlab-runner-windows-amd64 file to gitlab-runner
4. go to settings --> ci/cd --> runners(expand) --> new project --> enter the details --> copy the token
5. install in windows machine using powershell or cmd
![image5](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20122537.png)
## 24. Creating amazone account,i am role, vpc, availability zone etc...
## 25. Install and configure a local gitlab runner in aws ec2 instance with ubuntu
* make sure that tcp port 22 open for any ip address(0.0.0.0/0) for ssh
* create a new key pair of rsa and download it.
* launch the instance
* connect to ec2 by ssh client url i.e ssh -i "~/Downloads/runner-key.pem" ubuntu@<ipaddress>
* above url is found in ec2-->connect-->ssh client-->copy url
* install
  [Click here](https://docs.gitlab.com/runner/install/linux-repository.html)
  ![image6](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20133509.png)
## 26. Execute jobs on specific Runners
* By default our jobs runs on shared runner.
* We can run our job in specific runner by mentioning the **tags** in the job that we given to our runner.
```yml
image: alpine:3.18.4

workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy
  
run_unit_tests:
  tags:
    - ec2
    - aws
    - remote
  image: node:17-alpine
  stage: test
  before_script:
    - echo "preparing test data ..."
    - npm version
  script:
    - echo "Running tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  tags:
    - local
    - windows
  stage: test
  before_script:
    - echoss "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."
```
## 27. Add runner with Docker Executor
* Register a new runner
* Install a docker in new runner
* we can register multiple executor in same runner i.e docker, shell
```yml
image: alpine:3.15.1

workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always
stages:
  - test
  - build
  - deploy

variables:
  image_repository: docker.io/my-docker-id/myapp
  image_tag: v1.0
  
run_unit_tests:
  image: node:17-alpine3.14
  tags:                                       # uses wsl-docker-runner(project runner) with docker executor                                           
    - docker                                                                        
    - wsl
    - local
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running tests ..."
    - npm version
  after_script:
    - echo "Cleaning up temporary files.."

run_lint_tests:
  tags:                                       # uses wsl-shell-runner(project runner) with shell executor
    - shell
    - wsl
    - local
  stage: test
  before_script:
    - echo "preparing test data ..."
  script:
    - echo "Running lint tests ..."
  after_script:
    - echo "Cleaning up temporary files.."

build_image:                                   # by default uses shared runner with docker executor with image: alpine:3.15.1
  only:
    - main
  stage: build
  script:
    - echo "Building the docker image..."
    - echo "tagging the docker image"

push_image:
  only:
    - main
  needs:
    - build_image
  stage: deploy
  script:
    - echo "logging into docker registry..."
    - echo "pushing docker image to registry..."

deploy_image:
  only:
    - main
  stage: deploy
  script:
    - echo "deploying docker image to dev server..."
```
## 28. Group Runners(specific runner for multiple project)
* To use same runner for multiple project we can unlock it by **settings > ci-cd > runners > edit on runner > uncheck When a runner is locked, it cannot be assigned to other projects**
* Use group runner by configuring **home page(gitlab icon) > groups > new group > create new group > fill all details > we can add project**
* now open group **settings > ci-cd > runners > group runner** or **Build > runners > new group runner**  

## 29. Self-Managed GitLab Instance
* for security reasons.
* have full control over your infrastructure.
* have unused servers you want utilize.
* save infrastructure costs.

## 30. GitLab Runner versions
* GitLab instance and GitLab runner are the seperate program installed on separate machines.
* GitLab runner major.minor version should stay in sync with the gitlab major and minor version.
* Between minor version update, backward compatibility is guaranteed, but new features may require runner to be on the same minor version.
* if you use gitlab.com with own runner keep runner updated to the latest version, because gitlab.com update continuously!

## 31. Recape of GitLab Architecture
* we have Gitlab as saas or self-managed.
* 3 runners that can be registered to gitlab instance i.e shared, specific, group
* commonly used executor shell(windows,linux,macos), docker, k8s executor etc
* runners are reffered using *tags*.

## 32. Real life pipeline demo
* we build real-life pipeline for nodejs applicatiom.
* Our work floew would be **run unit tests(testing individual code components) > run SAST(Static application security testing for vulnerabilities) > build docker image(Dockerfile) > push to Docker Registry > deploy to DEV server (ec2) >Promote to STAGING > Promote to PRODUCTION**
* how to increment version of docker image dynamically.
* *.gitignore* file tells git which files to ignore when committing your project to the repository eg: files and folders , which are aren't useful to other team members like test result xml file.

## 33. Run unit test
* jobs can output an archive of files and directories.This output is called a job artifacts.
* **artifacts:reports** --> different reports like reports, code quality reports, security reports can be collected.
* **junit** --> collects JUnit report XML files.
* These are uploaded to GitLab as an artifact. 
* Artifact can be downloaded from **Build > pipelines > click on download button**
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

run_unit_tests:
  image: node:17-alpine3.14
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always              # upload report when test fail
    paths:
      - app/junit.xml         # Downloaded artifact will be in file structured format ( generally used when we have multiple files)
    reports:
      junit: app/junit.xml    # junit(report type) and app/junit.xml(location where report found) generally used to get junit visulisation in pipeline we use this
  
```
## 34. Build and push docker image
* Every GitLab project can have its own space to store its docker images.
* usage of package registry **Deploy > package registry(use GitLab as a private or public registry for variety of support package managers eg: maven,npm,pypl,NuGet)**
* usage of container registry **Deploy > container registry(registry to store docker image)**
* we needed to authenticate before we push the image. (using username and password, token or multifactor)
* GitLab provides temporary credentials for the container registry in your CI/CD pipeline( CI_REGISTRY_USER and CI_REGISTRY_PASSWORD in pre-defined env variable).
* once the image is build later it is pushed to container registry of GitLab.
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

stages:
  - test
  - build

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t registry.gitlab.com/jaisonvj/mynodeapp-cicd-project:1.0 .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD registry.gitlab.com
  script:
    - docker push registry.gitlab.com/jaisonvj/mynodeapp-cicd-project:1.0  # all docker commands are available at deploy > container registry
```
* improved code using ENV variable
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE/microservice/$MICROSERVICE
  IMAGE_TAG: "1.0"

stages:
  - test
  - build

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$IMAGE_TAG  # all docker commands are available at deploy > container registry
```
* we can define variable while running pipeline by **build > pipeline > run pipeline > add variable MICROSERVICE**
* we can define it globally by **settings > ci/cd > variables > add verable**
* we can also define within the pipeline script.
  
## 35. Deploy to DEV Server
* Create and configure the development server
* Create a new ec2-instance and create a new key pair for ec2-instance to ssh in aws
* ssh to ec2-instance and install docker
```sh
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER
```
* To GitLab we needed to give the private key(.pem) of deployment server to connect.
* provide key through variable **settings > variables > add variable > key:SSH_PRIVATE_KEY, value:<content of .pem> > check protect variable > Type:File add variable**
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$IMAGE_TAG  # all docker commands are available at deploy > container registry
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip > "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    docker run -d -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker run -d -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG
```
* In security group edit inbound rule to allow port 3000 from anywhere.
* now website is accessable in browser.

## 36. GitLab Environments
* we use it to redirect to application url when we click on open on env we setted.
* if no environment with that name exists, a new one is created
* for environment navigate to **operate > Environment >** now we can see development environment we configured here
* GitLab provides a full histroy of deployment of each environment.
* you can always know what is deployed on your servers.
```yml

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://192.168.49.237:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$IMAGE_TAG  # all docker commands are available at deploy > container registry
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip > "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    docker run -d -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker run -d -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG
  environment:
    name: development
    url: $DEV_ENDPOINT

```
## 37. CD with Docker-Compose
* Docker run works only for first time because of port is already occupied.
* Docker Compose is a tool to define and run multiple containers.
* Everything is defined in one YAML file.
* you can spin everything up and tear it all down with just single command.
* create a file in home called **docker-compose.yml**
```yml
version: "3.3"
services:
  app:
    image: registry.gitlab.com/jaisonvj/mynodeapp-cicd-project:1.1 # image name in [ deploy > container registry > image > tag(copy to clipboard) ]
    ports:
      - 3000:3000
    # above is same as docker run -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG
```
* use above instead of docker run to start the container.
* we needed to install docker compose in development server to run docker compose file
```sh
sudo apt install docker-compose
```
* whole code docker-compose available for gitlab,git-lab runner but not development server, so copy file from gitlab runner to dev server
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://192.168.49.237:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$IMAGE_TAG  # all docker commands are available at deploy > container registry
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - docker-compose -f docker-compose.yaml down # stop all container and not fail if no container is running
    - docker-compose -f docker-compose.yaml up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT
```
* lets optimise the above things
* lets it use default docker-compose.yaml in home directory, withot specifying -f
* lets replace with variable that is hard coded in docker-compose and version change to *dynamically set*
* for deployment server we needed to export the variable and in gitlab runner we can declare globally or export the variable.
* optimised **docker-compose.yaml**
```yml
version: "3.3"
services:
  app:
    image: ${DC_IMAGE_NAME}:${DC_IMAGE_TAG} # image name in [ deploy > container registry > image > tag(copy to clipboard) ]
    ports:
      - 3000:3000
    # above is same as docker run -p 3000:3000 $IMAGE_NAME:$IMAGE_TAG
```
* optimised **.gitlab-ci.yml**
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://192.168.49.237:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .

push_image:
  stage: build
  needs:
    - build_image
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$IMAGE_TAG  # all docker commands are available at deploy > container registry
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    export DC_IMAGE_NAME=$IMAGE_NAME &&
    #    export DC_IMAGE_TAG=$IMAGE_TAG &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - export DC_IMAGE_NAME=$IMAGE_NAME
    - export DC_IMAGE_TAG=$IMAGE_TAG
    - docker-compose down # stop all container and not fail if no container is running
    - docker-compose up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT
```
## 38.Extend and optimize pipeline to a real life pipeline
* Dynamic versioning --> dynamically set an increment version when we build the docker image.
* add 3 more job (static application security test, dev-->staging-->production).

## 39. Dynamic versioning
* when ever a pipeline run new image tag has to be build.
* application versioning 1.4.2(major, minor, patch)
* major changes - related to incompatible API changes. eg: Replace Framework, New feature
* minor changes - new function in a backward-compatible manner. eg: new minor feature, bigger bugfix
* patch changes - related to small bugfixes and changes, which are backward compatible. eg: small changes, bugfix
* version is defined in the configuration file of the package manager / build tool of the application. eg: npm, maven, gradle, yarn
* in our application we use npm. where version is defined in package.json
* now we want to read application verion from package.json
* To parse json query. please install **jq tool** in the runner
```sh
sudo apt install jq
```
* Every job gets executed in its own new environment, so variables available only in the job it was defined.
* How do we pass **data between jobs ?**
* For this we use artifacts attribute.
* The artifacts are Send to GitLab after the job finishes and available for download in the GitLab UI.
* we save the version in a file and once job is finished file is uploaded to the gitLab artifact.
* later we import this for other JOB.
* By **default** jobs in the later stages automatically download all the artifacts created by jobs in earlier stages.
* For jobs in the same stage, the artifacts **won't be downloaded** automatically.
* To download the artifacts in same stage we use **"dependencies"** attribute to define a list of jobs to fetch artifacts from.
* with empty array i.e **dependencies: []**, you configure the job to not download any artifacts.
* BY default **needs** artifacts from the job listed will be downloaded.
* There is no need to define "dependencies" separately.
*  
* open **.gitlab-ci.yml**
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://192.168.49.237:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  before_script:
    - export PACKAGE_JSON_VERSION=$(cat app/package.json | jq -r .version)      #json query helps to pare json object and get value of it
    - export VERSION=$PACKAGE_JSON_VERSION-$CI_PIPELINE_IID
    - echo $VERSION > version-file.txt
  script:
    - docker build -t $IMAGE_NAME:$VERSION .
  artifacts:
    paths:
      - version-file.txt

push_image:
  stage: build
  needs:
    - build_image
  #dependencies:                                # to avilable artifact of previous job in same stage
    #- build_image 
  tags:
    - local
    - wsl
    - shell
  before_script:
    - export VERSION=$(cat version-file.txt)
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$VERSION 
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
    - export VERSION=$(cat version-file.txt)
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    export DC_IMAGE_NAME=$IMAGE_NAME &&
    #    export DC_IMAGE_TAG=$VERSION &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - export DC_IMAGE_NAME=$IMAGE_NAME
    - export DC_IMAGE_TAG=$VERSION
    - docker-compose down # stop all container and not fail if no container is running
    - docker-compose up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT
```
* Dotenv File is a npm package that automatically loads environment variables from a .env file into the processand alos in Gitlab.
* Dotenv Format , one variable defination per line, each line must be of the form: VARIABLE_NAME=ANY_VALUE
* collected variables are registered as runtime-created variables of the job.
* jobs in later stages can use the variable in the scripts.
* same dependency and needs rules apply here
    1. All artifacts of previous stage is available to next stage by defaults.
    2. All artifacts of previous job in same stage is not available to next job in same stage by default.
    3. To available the artifacts of same stage from previous job to next job we can use **dependency** attribute , if in case **needs** atribute already used then there is no needed use of dependency attribute.
    5. if in case we not needed to inherite the artifacts from prvious stage or job, we can set **dependency: []**
       
```yml
  workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://192.168.49.237:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  before_script:
    - export PACKAGE_JSON_VERSION=$(cat app/package.json | jq -r .version)      #json query helps to pare json object and get value of it
    - export VERSION=$PACKAGE_JSON_VERSION-$CI_PIPELINE_IID
    - echo "VERSION=$VERSION" >> build.env
    - echo "MY_ENV=value" >> buid.env
  script:
    - docker build -t $IMAGE_NAME:$VERSION .
  artifacts:
    reports:
      dotenv: build.env

push_image:
  stage: build
  needs:
    - build_image
  #dependencies:                                # to avilable artifact of previous job in same stage
    #- build_image 
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$VERSION 
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    export DC_IMAGE_NAME=$IMAGE_NAME &&
    #    export DC_IMAGE_TAG=$VERSION &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - export DC_IMAGE_NAME=$IMAGE_NAME
    - export DC_IMAGE_TAG=$VERSION
    - docker-compose down # stop all container and not fail if no container is running
    - docker-compose up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT
```
## 40. Caching in GitLab CI/CD Speed up the pipeline
* make the pipeline faster.
* each job runs in its own isolated environment.
* Starting from a fresh new environment jobs don't affect each other, no unexpected side-effects.
* generally used when we want the dependency to reuse in the job.
* Downloading the multiple package takes time, this slows down the CI/CD
* We neede node_modules(folder stored all downloaded dependency) from previous pipeline run, instead of downloading from the internet again.
* Artifacts vs Cache
* **Artifacts**
* Job artifacts get uploaded and save on the GitLab server and made available for the jobs.
* Use artifacts to pass intermediate build result between stages
* **Cache**
* use cache for dependencies, like packages you downloaded from the internet.
* cache is stored in GitLab Runner!
* if the jobs run on the same runner, they can re-use the local cache on the server.
* **Distributed cache**
* For caches to work efficiently, use less runners for all your jobs
* A cache would need to be created on each runner's server
* configure a distributed caching, if you use multiple runners eg:cache is stored in S3 buckets(Central cache storage)
* Download from remote storage again over the internet.
* still faster to download 1 zip file,instead of each dependency separately.
* **Configure a Cache**
* it is defined using cache attribute.
* give each cache a unique identifying key, if not set the default key is "default"
* all jobs that use the same cache key use the same cache.
* Common naming of cache keys are cache_main,cache_dev, the jobs that run for a specific branch, will share the same cache.
* Instead of using a hardcoded string, you can use a predefined variables or a combination of the string and variable.
* pull-push --> job downloads the cache when the job starts and upload changes to the cache when the job ends.its a default policy.
* **Linting**
* A "Linter" is a static code analysis tool, it checks your source code for programming errors and stylistic error.
* **Configure Volume for Docker Executor**
* while two job uses the same cache ,while running in parallel it causes the error so give second one for pull permission, which download the cache never upload the cache.
* we will be also using npm install because our job should never depends on a cache to be available, caching is an optimisation, but it isn't guaranteed to always work.
* we can also have seperate job to push the cache and use pull in other job also.
* If we are using docker executor the problem is cache gets created inside the container, when job finishes, the container is removed.
* By default, data inside is not persisted.
* for this we needed to configure docker volume, which replicate the data to host.
* all the runner configaration stored in **/etc/gitlab-runner/config.tomal**
* Here we can see runners and configured executor.
* To persist the cache add the cache directory in /etc/gitlab-runner/config.tomal of docker runner session i.e
![image7](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-12-20%20134741.png)
```
cache_dir = "/cache"
```
* In job2 terminal, under npm install command , if uptodate is present. then cache is working fine
![image8](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-12-20%20165332.png)
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://localhost:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  cache:
    key: "$CI_COMMIT_REF_NAME"  # Gives name to cache by variable(The branch or tag name for which project is built).
    paths:
      - app/node_modules
    policy: pull-push          # download and when job is finshes uploads or updates the cache
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

run_lint_checks:
  image: node:17-alpine3.14
  stage: test
  cache:
    key: "$CI_COMMIT_REF_NAME"
    paths:
      - app/node_modules
    policy: pull                      #only download no upload
  tags:
    - docker  
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - echo "Running lint checks"
    
build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  before_script:
    - export PACKAGE_JSON_VERSION=$(cat app/package.json | jq -r .version)      #json query helps to pare json object and get value of it
    - export VERSION=$PACKAGE_JSON_VERSION-$CI_PIPELINE_IID
    - echo "VERSION=$VERSION" >> build.env
    - echo "MY_ENV=value" >> buid.env
  script:
    - docker build -t $IMAGE_NAME:$VERSION .
  artifacts:
    reports:
      dotenv: build.env

push_image:
  stage: build
  needs:
    - build_image
  #dependencies:                                # to avilable artifact of previous job in same stage
    #- build_image 
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$VERSION 
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    export DC_IMAGE_NAME=$IMAGE_NAME &&
    #    export DC_IMAGE_TAG=$VERSION &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - export DC_IMAGE_NAME=$IMAGE_NAME
    - export DC_IMAGE_TAG=$VERSION
    - docker-compose down # stop all container and not fail if no container is running
    - docker-compose up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT

```
* This is a way to speed up your job execution by reusing existing data.
* **Clearing the cache**
* nagivate to **CI/CD > pipelines > click on Clear runner caches**.
* Clearing the caches manually will not delete old cache.
* each time you clear the cache manually, the internal cache name is updated, old cache is not deleted eg: format "cache-index", index is incremented by one.
* do delete old cache, we should ssh and maually locate it and delete it.
* below image shows where cache stored in docker,shell and other executor.
![image9](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-12-20%20172210.png)
* To delete it permanently locate it by,
![image10](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-12-20%20171428.png)
![image11](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-12-20%20172602.png)
* All caches defined for a job are archived in a single cache.zip file

## 41. Testing in CI/CD Add SAST job
* Now we will use SAST and DAST for security.
* we include **job Templates**, these are specific jobs provided by GitLab, which you can included.
* it is auto devops concept.
* There are different type of testing such as unit Testing, Functional Testing, Integration Testing, API Testing, UI Testing, Regression Testing.
* Developers and test engineers create test scenarios and write tests.
* we will focus on running SAST tests, using existing GitLab jobs, which have everything pre-confiured and to include it in your own CI/CD pipeline.
* **Template for SAST**
* GitLab provide Job templates for different tasks and for different programming languages and technologies.
* all templates are available at [Click here](https://gitlab.com/gitlab-org/gitlab-foss/tree/master/lib/gitlab/ci/templates)
* to include any job template we have feature called **include:**
* GitLab detects the programing langaue automatically when we include the template and that part of code is only executed.
```yml
workflow:
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE != "merge_request_event"
      when: never
    - when: always

variables:
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  IMAGE_TAG: "1.1"
  DEV_ENDPOINT: http://localhost:3000

stages:
  - test
  - build
  - deploy

run_unit_tests:
  image: node:17-alpine3.14
  stage: test
  cache:
    key: "$CI_COMMIT_REF_NAME"  # Gives name to cache by variable(The branch or tag name for which project is built).
    paths:
      - app/node_modules
    policy: pull-push          # download and when job is finshes uploads or updates the cache
  tags:
    - docker
    - wsl
    - local
  before_script:
    - cd app
    - npm install
  script:
    - npm test
  artifacts:
    when: always                 
    paths:
      - app/junit.xml          
    reports:
      junit: app/junit.xml    

sast:
  stage: test
  
build_image:
  stage: build
  tags:
    - local
    - wsl
    - shell
  before_script:
    - export PACKAGE_JSON_VERSION=$(cat app/package.json | jq -r .version)      #json query helps to pare json object and get value of it
    - export VERSION=$PACKAGE_JSON_VERSION-$CI_PIPELINE_IID
    - echo "VERSION=$VERSION" >> build.env
    - echo "MY_ENV=value" >> buid.env
  script:
    - docker build -t $IMAGE_NAME:$VERSION .
  artifacts:
    reports:
      dotenv: build.env

push_image:
  stage: build
  needs:
    - build_image 
  tags:
    - local
    - wsl
    - shell
  before_script:
    - echo "Docker registry url is $CI_REGISTRY"
    - echo "Docker registry username is $CI_REGISTRY_USER"
    - echo "Docker registry image repo is $CI_REGISTRY_IMAGE"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker push $IMAGE_NAME:$VERSION 
  
deploy_to_dev:
  stage: deploy
  tags:
    - local
    - wsl
    - shell
  #before_script:
    #- chmod 400 $SSH_PRIVATE_KEY
  script:
    #- scp -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ./docker-compose.yaml ubuntu@<public ip>:/home/ubuntu #copy docker compose file
    #- ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY ubuntu@<public ip> "
    #    docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
    #    export DC_IMAGE_NAME=$IMAGE_NAME &&
    #    export DC_IMAGE_TAG=$VERSION &&
    #    docker-compose -f docker-compose.yaml down &&
    #    docker-compose -f docker-compose.yaml up -d"
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - pwd
    - export DC_IMAGE_NAME=$IMAGE_NAME
    - export DC_IMAGE_TAG=$VERSION
    - docker-compose down # stop all container and not fail if no container is running
    - docker-compose up -d # run in detached mode
  environment:
    name: development
    url: $DEV_ENDPOINT

include:
  - template: Jobs/SAST.gitlab-ci.yml

```
* **Pipeline Templates** it provides an end-to-end CI/CD workflow.
* it's not included in another main pipeline configuration, but rather used by itself
* go to project which doesnot have pipeline navigate to **CI/CD > Pipelines > scroll down to see list of pipeline templates**

## 42. CD - Promote to Staging and Production


