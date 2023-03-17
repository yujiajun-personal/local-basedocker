#!/usr/bin/groovy
@Library('local-pipeline-lib@dev')_

import com.ximu.cicd.config.Config

def init = {
    //Environment variables that are required for pipeline
    env.SERVICE_NAME        = 'local-basedocker'
    env.MAJOR_VERSION       = '1.0.0'
    env.QA_OWNERS           = 'yujiajun'
    env.RD_OWNERS           = 'yujiajun'
    env.BUILD_VERSION       = utility.getBuildVersion(env.MAJOR_VERSION, env.BUILD_NUMBER)  //Example: 1.0.0.00001

    //ciPipeline.ciResults.enableUT = false
    //ciPipeline.ciResults.enableSST = false
    //ciPipeline.ciResults.enableSIT = false
    //ciPipeline.ciResults.enableGroupNotification = false
}

def customizedProperties = {
    properties(
        [
            parameters(
                [   
                    string(name: 'purpose', defaultValue: 'Lab Automation testing', description: 'The purpose for the this testing'),
                    choice(
                        name:'platform',
                        choices:'ESXI\nHyper-V',
                        description:'The platform installing Service Gateway'
                    )
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
    sh "echo 1"
    /*
    def imageTag = utility.getImageTag(env.BRANCH_NAME, env.BUILD_VERSION)
    def latestImageTag = utility.getImageTag(env.BRANCH_NAME, 'latest')
    def imageName = utility.getImageName(env.SERVICE_NAME, imageTag)
    def latestImageName = utility.getImageName(env.SERVICE_NAME, latestImageTag)
    echo "image name: ${imageName}"
    withDockerRegistry(credentialsId: "ecr:us-west-2:${Config.SG_ECR_CREDENTIAL_RW}", url: Config.SG_ECR_URL) {
        IMAGE = docker.build(imageName, "--pull .")
        IMAGE.push()
        IMAGE.push(latestImageTag)
    }
    
    ciPipeline.ciResults.buildResult = 'SUCCESS'
    ciPipeline.ciResults.buildImages = "- ${imageName}<br>- ${latestImageName}"
    */
}

node('MagicBox-Builder') {
    ciPipeline (
        initStage: init,
        customizedProperties: customizedProperties,
        publishArtifactStage: publishArtifact
    )
}
