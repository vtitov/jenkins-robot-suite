*** Settings ***
Documentation   pipeline test.
Library         HttpRequestLibrary
Library         Collections
Library         OperatingSystem
Library         XML
Library         com.github.vtitov.testing.jenkins.robot.LoremIpsum
Library         String
Resource        libs/Libs.robot
Resource        libs/PipelineApi.robot

Suite Setup     Init System
Suite Teardown  Teardown System
Test Timeout    50 minutes
#Test Timeout    20 minutes
#Test Timeout    100500 minutes

*** Variables ***

*** Test Cases ***

Execute pipelines
    Log  TODO
#    ${resp_json}     Send GenerigWebhook     ${jenkins_pipeline_session}
#    Wait for job is success             job1  ${jenkins_pipeline_session}
#    Wait for job is success             job2  ${jenkins_pipeline_session}

*** Keywords ***
Init System
    Create Connections
    Create Test Files

Teardown System
    Remove Test Files

Create Connections
    ${session}   Create Pipelines Session  ${JENKINS_URL}
    Set Suite Variable  ${jenkins_pipeline_session}  ${session}
