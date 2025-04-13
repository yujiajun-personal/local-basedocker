#!/usr/bin/groovy
@Library('local-pipeline-lib@master')_
import com.ximu.cicd.config.Config

def init = {
    //Environment variables that are required for pipeline
    env.SERVICE_NAME        = 'local-basedocker'
    env.BRANCH_NAME         = "master"
    env.MAJOR_VERSION       = '1.0.0'
    env.QA_OWNERS           = 'yujiajun'
    env.RD_OWNERS           = 'yujiajun'
    env.BUILD_VERSION       = utility.getBuildVersion(env.MAJOR_VERSION, env.BUILD_NUMBER) //example 1.0.0.00040
    //echo "${env.BUILD_NUMBER}" example 40
    //echo "${env.BUILD_VERSION}"
}

def customizedProperties = {
    properties(
        [
            parameters(
                [   
                    string(name: 'purpose', defaultValue: 'To build an common docker image', description: 'The purpose for the this testing')
                ]
            ),
            buildDiscarder(
                logRotator(
                    daysToKeepStr: '365'
                )
            ),
            disableConcurrentBuilds()
        ],
    )
}

def publishArtifact = {
    def imageTag = utility.getImageTag(env.BRANCH_NAME, env.BUILD_VERSION)
    def latestImageTag = utility.getImageTag(env.BRANCH_NAME, "latest")
    def imageName = utility.getImageName(env.SERVICE_NAME, imageTag)
    def latestImageName = utility.getImageName(env.SERVICE_NAME, latestImageTag)
    echo "image name: ${imageName}" //yujiajundocker/local-basedocker:dev-1.0.0.00008 or yujiajundocker/local-basedocker:1.0.0.00008

    docker.withRegistry(Config.DOCKERHUB_URL, Config.CREDENTIAL_FOR_LOGIN_DOCKERHUB) {
        echo "${imageName}"
        echo "${latestImageName}"

        serviceImage = docker.build(imageName, "-f ./Dockerfile .")
        serviceImage.push()
        serviceImage.push(latestImageTag)
        serviceImage.rmi()
    }
    //sh """ docker rmi -f $(docker images | grep '${env.SERVICE_NAME}' | awk '{print \$3')"""
    ciPipeline.ciResults.buildResult = 'SUCCESS'
    
}

def completionWork = {
    sh "docker rmi -f \$(docker images --filter='reference=*/*${env.SERVICE_NAME}*:${imageTag}' -q) || echo no service docker image to remove"
}

def cleanup = {
    sh "docker rmi -f \$(docker images --filter='reference=*/*${env.SERVICE_NAME}*' -q) || echo no service docker image to remove"
}

node {
    ciPipeline (
        initStage: init,
        customizedProperties: customizedProperties,
        publishArtifactStage: publishArtifact,
        completionWorkStage:completionWork
        cleanupStage:cleanup
    )
}
