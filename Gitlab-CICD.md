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
[image5](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-08%20122537.png)
## 24. Creating amazone account,i am role, vpc, availability zone etc...
## 25. Install and configure a local gitlab runner in aws ec2 instance with ubuntu
* make sure that tcp port 22 open for any ip address(0.0.0.0/0) for ssh
* create a new key pair of rsa and download it.
* launch the instance
* connect to ec2 by ssh client url i.e ssh -i "~/Downloads/runner-key.pem" ubuntu@<ipaddress>
* above url is found in ec2-->connect-->ssh client-->copy url
* install
  [Click here](https://docs.gitlab.com/runner/install/linux-repository.html)
  ![image6](https://github.com/jaisonvj/wsl/commit/eacf515c46e67419e682c980f90ea0bdcf46109b)
## 26. Execute jobs on specific Runners
* 


