
# Introduction
This repo demonstrate how to setup Jenkins using Docker.

<br>

### Installing Docker for Windows
1. Download the docker desktop installer from the Official Docker Website.
2. To specify custom path to install Docker, cd to the folder with the downloaded Docker Desktop Installer and run the below command in `CMD` as admin.
    ```
    start /w "" "Docker Desktop Installer.exe" install -accept-license  --installation-dir="D:\Program Files (x86)\Docker" --wsl-default-data-root="D:\Program Files (x86)\Docker" 
    ```
3. Double-check if your user account is part of the `docker-users` group. Click Window+R and run `netplwiz`.
    - If not in the group, manually add your window user account into `docker-users` and re-login.
        ```
        net localgroup docker-users "your-user-id" /ADD
        ```
    - Ensure that `docker-users` have full permission in the installed Docker folder path.

4. If there's any wsl error encountered when running docker, try below steps. 
  - Disable these features by running below powershell commands as admin.
    ```
    DISM /Online /disable-Feature /FeatureName:VirtualMachinePlatform
    DISM /Online /disable-Feature /FeatureName:HypervisorPlatform
    DISM /Online /disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux
    ```
  - Restart your computer.
  - Re-enable those features by running below powershell commands as admin.
    ```
    DISM /Online /enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux
    DISM /Online /enable-Feature /FeatureName:VirtualMachinePlatform
    DISM /Online /enable-Feature /FeatureName:HypervisorPlatform
    ```


### Installing Jenkins using Docker
1. Create a bridge network in Docker
    ```
    docker network create jenkins
    ```

2. Build the docker image
    ```
    docker build -t myjenkins-blueocean:2.479.1-1 .
    ```

3. Run the docker image
    ```
    docker run --name jenkins-blueocean --restart=on-failure --detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.479.1-1
    ```

4. Copy the initial jenkins admin password
    ```
    docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
    ```

5. Navigate to [http://localhost:8080/](http://localhost:8080/) and unlock with the initialAdminPassword copied.

6. Stick on jenkins path in bash
    ```
    docker exec -it jenkins-blueocean bash
    ```

7. Move to jenkins_home, under workspace is where your project's file are stored in. 
    ```
    cd /var/jenkins_home
    ```

8. Initialize your workspace directory accordingly if needed. The path will look like `/var/jenkins/home/workspace/your-project-name/`.

<br>

### Build your jenkins pipeline
1. Create a new pipeline in the jenkins UI.
2. Declare pipeline using repo's [Jenkinsfile](/jenkins/Jenkinsfile)
3. Recommended options:
    - Do not allow concurrent builds and abort previous builds if new triggers came in
    - Preserve stashes from most recent completed build

<br>

## Installation Reference:
https://www.jenkins.io/doc/book/installing/docker/