#!/usr/bin/groovy
@Library('local-pipeline-lib@dev')_
import com.ximu.cicd.config.Config

def init = {
    //Environment variables that are required for pipeline
    env.SERVICE_NAME        = 'local-basedocker'
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
            )
        ],
    )
}

def publishArtifact = {
    //build and push image
    echo "${env.BRANCH_NAME}"
    echo "${env.BRANCH_NAME}"
    def imageTag = utility.getImageTag(env.BRANCH_NAME, env.BUILD_VERSION)
    def latestImageTag = utility.getImageTag(env.BRANCH_NAME, 'latest')
    def imageName = utility.getImageName(env.SERVICE_NAME, imageTag)
    def latestImageName = utility.getImageName(env.SERVICE_NAME, latestImageTag)
    echo "image name: ${imageName}"
    withDockerRegistry(credentialsId: Config.DOCKERHUB_CREDENTIAL, url: Config.DOCKERHUB_URL) {
        IMAGE = docker.build(imageName, "--pull .")
        IMAGE.push()
        IMAGE.push(latestImageTag)
    }

    withCredentials([usernamePassword(credentialsId: Config.DOCKERHUB_CREDENTIAL, passwordVariable: 'password', usernameVariable: 'username')]) {
        sh """ docker login -u $username -p $password; \
                docker pull ${Config.BUILDER_IMAGE_COMMON} 
                echo ${Config.BUILDER_IMAGE_COMMON}
        """   
    }

    ciPipeline.ciResults.buildResult = 'SUCCESS'
    ciPipeline.ciResults.buildImages = "- ${imageName}<br>- ${latestImageName}"
    
}

node {
    ciPipeline (
        initStage: init,
        customizedProperties: customizedProperties,
        publishArtifactStage: publishArtifact
    )
}
