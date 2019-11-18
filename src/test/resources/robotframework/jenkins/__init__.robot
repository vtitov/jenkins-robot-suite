*** Settings ***
Library         OperatingSystem
Library         Process
Library         HttpRequestLibrary
Library         String
Library         Collections
Resource        libs/Libs.robot
Resource        libs/PipelineApi.robot


Suite Setup     Initialize System
Suite Teardown  Teardown System
#Test Timeout    20 minutes
Test Timeout    5 minutes
#Test Timeout    100500 minutes

*** Variables ***

${JENKINS_HANDLE}       None
@{model_job_list}       pipeline01   pipeline02
${copy_command}         echo fake copy command

*** Keywords ***

Initialize System
    Make Jenkins Variables Global
    Init Jenkins
    Ensure Jenkins Is Running   ${JENKINS_HANDLE}  ${JENKINS_URL}
    Check all pipelines exist
    Idle pipelines launch

Make Jenkins Variables Global
    Set Global Variable  ${JENKINS_URL}  ${JENKINS_URL}

Init Jenkins
    Log  Suite Setup with maven_test_classpath ${maven_test_classpath}
    Launch JENKINS  ${jenkins_war_path}  ${JENKINS_PORT}  ${java_util_logging_config_file}

Launch JENKINS
    [Arguments]    ${war_path}   ${jenkins_port}    ${jul_properties}
    Log                 Starting ${war_path} on port ${JENKINS_PORT} with log properties from ${java_util_logging_config_file}
    ${JH}=  Start Process   java
    ...         -Djava.util.logging.config.file\=${jul_properties}
    ...         -Djenkins.install.runSetupWizard\=false
    ...         -Dpermissive-script-security.enabled\=true
    ...         -jar    ${war_path}
    ...         --httpPort\=${jenkins_port}
    ...         alias=jenkins
    ...         env:JAVA_ARGS=-Xmx1024m
    ...         env:CASC_JENKINS_CONFIG=src/test/resources/casc-jenkins
    ...         env:COPY_COMMAND=${copy_command}
    ...         env:JENKINS_HOME=target/work-jenkins/
    ...         stdout=target/stdout_jenkins.txt
    ...         stderr=target/stderr_jenkins.txt
    ${JENKINS_HANDLE}  Set Variable  ${JH}
    Log                 Started ${WAR_PATH} on ${JENKINS_PORT} with handle ${JENKINS_HANDLE}
    [Return]  ${JH}

Check all pipelines exist
    ${json}  Get jenkins jobs json
    ${list}=    Create List

    #Sleep   100500s
    #FOR   ${index}  IN RANGE  4
    #        Append To List	${list}     ${json}[jobs][${index}][name]
    #END
    FOR   ${index}  IN RANGE  2
            Append To List	${list}     ${json}[jobs][${index}][name]
    END

    #Lists Should Be Equal  ${list}  ${model_job_list}

# to let pipelines apply all triggers/variables
Idle pipelines launch
    FOR     ${job}  IN  @{model_job_list}
            Log to Console      Build Job ${job}
            Post Request        jenkins    /job/${job}/build
            Sleep   15s
    END

    # wait for all jobs to start
    Sleep   10s

    # check for all jobs to finish
    FOR   ${index}  IN RANGE  30
            ${json}  Get jenkins jobs json
            ${all_jobs_finished}    Check all jobs finished      ${model_job_list}
            Exit For Loop If    $all_jobs_finished == 'YES'
            Sleep  5s
    END

Check all jobs finished
    [Arguments]     ${model_job_list}
    ${all_jobs_finished}=    	Set Variable	None
    ${list}=    Create List
    FOR     ${job}  IN  @{model_job_list}
            ${active}   Get is job active   jenkins   ${job}
            Log to Console  Job ${job} is finished: ${active}
            Run Keyword If    ${active} > -1    Append to list  ${list}   NO
    END
    Log to Console          List ${list}
    ${length}=              Get length  ${list}
    Log to Console          List length ${length}
    ${all_jobs_finished}    Set variable if     ${length} > 0     NO       YES
    Log to Console          All jobs is finished: ${all_jobs_finished}
    [Return]    ${all_jobs_finished}

Teardown System
    Log             Terminate JENKINS w/ HANDLE ${JENKINS_HANDLE}
    Terminate Process  handle=${JENKINS_HANDLE}
