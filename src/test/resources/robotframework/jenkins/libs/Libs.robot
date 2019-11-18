*** Variables ***
${JENKINS_URL}          http://localhost:${JENKINS_PORT}

*** Keywords ***

Ensure Jenkins Is Running
    [Arguments]   ${jenkins_handle}  ${jenkins_url}
    Run Keyword Unless  '${jenkins_handle}' == 'None'   Process Should Be Running   ${jenkins_handle}
    Wait For Jenkins to Start   ${jenkins_url}

Wait For Jenkins to Start
    [Timeout]   5 minutes
    [Arguments]     ${jenkins_url}
    ${jenkins_session}  Create Pipelines Session  ${jenkins_url}
    Log To Console     Waiting for the connection to Jenkins: ${jenkins_url} ${\n}
    FOR    ${index}    IN RANGE  999
        ${mod}  Evaluate  ${index} % 5
        Run Keyword If  '${mod}' == '0'   Log To Console  Connecting to Jenkins: attempt ${index}
        ${status}    ${message}=   Run Keyword And Ignore Error    Connect To Jenkins     ${jenkins_session}
        Log     ${status}
        Exit For Loop If     $status == 'PASS'
        Sleep   1s
    END
    Log To Console     Jenkins is running!

Create Pipelines Session
    [Arguments]  ${url}
    ${headers}=    Create Dictionary    Accept-Encoding  identity      Accept-Language  en     Accept  application/json    Content-Type  application/json
    ${session_name}=     Set Variable    pipelines
    Create Session          ${session_name}    ${url}   headers=&{headers}
    [return]  ${session_name}

Connect To Jenkins
    [Arguments]     ${jenkins_session}
    ${resp}    Get Request    ${jenkins_session}    /
    Response Code Should Be   ${jenkins_session}  200

Get jenkins jobs json
    Create Session      jenkins  ${JENKINS_URL}
    ${resp}  Get Json   jenkins  /api/json?tree=jobs[name]
    [Return]            ${resp}

Post Json
    [Arguments]     ${session}      ${url}     ${data}      ${expected_code}=200
    ${resp}     Post Request        ${session}    ${url}    data=${data}

Get Json
    [Arguments]     ${session}    ${url}   ${expected_code}=200
    ${resp}    Get Request      ${session}    ${url}
    Response Code Should Be     ${session}    ${expected_code}
    ${jsondata}    To Json      ${resp.content}
    [Return]  ${jsondata}
