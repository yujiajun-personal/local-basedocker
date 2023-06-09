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
    git url:"git@github.com:yujiajun-personal/local-basedocker.git",
        credentialsId: Config.SSH_CREDENTIAL_FOR_PERSONAL_GITHUB,
        branch: "master"

    def imageTag = "${env.BUILD_VERSION}"
    def latestImageTag = "latest"
    def imageName = utility.getImageName(env.SERVICE_NAME, imageTag)
    def latestImageName = utility.getImageName(env.SERVICE_NAME, latestImageTag)
    echo "image name: ${imageName}"

    withCredentials([usernamePassword(credentialsId: Config.DOCKERHUB_CREDENTIAL, passwordVariable: 'password', usernameVariable: 'username')]) {
        sh """ docker login -u $username -p $password; \
                docker build -t ${imageName}  -f ./Dockerfile .; \
                docker push ${imageName}; \

                docker tag ${imageName} ${latestImageName}; \
                docker push ${latestImageName}
        """   
    }

    ciPipeline.ciResults.buildResult = 'SUCCESS'
    
}

node {
    ciPipeline (
        initStage: init,
        customizedProperties: customizedProperties,
        publishArtifactStage: publishArtifact
    )
}
