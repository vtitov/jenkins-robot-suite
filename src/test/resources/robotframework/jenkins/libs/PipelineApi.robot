*** Settings ***
Documentation   Contains keywords send various post request to jenkins pipelines

*** Variables ***

*** Keywords ***
Create Test Files
    Create File             ${TEMPDIR}/dummy-with-mask.txt
    Create File             ${TEMPDIR}/dummy-with-mask2.txt

Remove Test Files
    Remove File             ${TEMPDIR}/dummy-with-mask.txt
    Remove File             ${TEMPDIR}/dummy-with-mask2.txt

Check build description
    [Arguments]     ${session}  ${job_name}     ${model_descr}
    ${get_description}        Set Variable  False
    FOR  ${index}  IN RANGE  30
        ${descr}       Get Json       ${session}       /job/${job_name}/lastBuild/api/json?tree=description
        ${get_description}=    Set Variable If      '${descr}[description]' != 'None'      True
        Run Keyword If      '${descr}[description]' != 'None'       Should Be Equal As Strings      ${descr}[description]    ${model_descr}
        Exit For Loop If     ${get_description}
        Sleep   3s
    END
    Should Be Equal         ${get_description}      True

Check trigger reponse
    [Arguments]         ${resp_json}    ${job_name}
    Should Be True      ${resp_json}[data][triggerResults][${job_name}][triggered]

Get last build id
    [Arguments]     ${session}      ${job_name}
    ${json}         Get Json        ${session}       /job/${job_name}/lastBuild/api/json?tree=id
    ${id}=          Set Variable    ${json}[id]
    [Return]        ${id}

Wait for build to start
    [Arguments]             ${session}      ${job_name}     ${build_num}
    ${build_started}        Set Variable  NO
    FOR  ${index}  IN RANGE  15
        Log to Console      get params of ${job_name}, attempt ${index}
        ${resp}             Get Request      ${session}    /job/${job_name}/${build_num}/api/json
        ${build_started}    Set Variable If   ${resp.status_code} == 200  YES
        Exit For Loop If    ${resp.status_code} == 200
        Sleep   3s
    END
    Should Be Equal  ${build_started}  YES

Wait for job is success
    [Arguments]     ${job_name}     ${session}
    FOR  ${index}  IN RANGE  60
        Log to Console      Getting stages of job ${job_name}: attempt ${index}
        ${stages}          Get stages    ${session}   ${job_name}
        ${job_success}=     Run Keyword And Return Status   Should Be Equal As Strings  ${stages}[status]   SUCCESS
        ${job_fails}=       Run Keyword And Return Status   Should Be Equal As Strings  ${stages}[status]   FAILED
        Run Keyword If      ${job_success} == True      Return From Keyword
        Run Keyword If      ${job_fails} == True        Fail  ${job_name} is finished with failure
        Sleep   1s
    END
    Fail

Get is job active
    [Arguments]  ${session}    ${job_name}
    ${json}             Get Json        ${session}  /job/${job_name}/api/json?tree=color
    ${color}=           Set Variable    ${json}[color]
    ${job_active}=    Evaluate  $color.find('anime')
    [Return]    ${job_active}

Get params
    [Arguments]     ${session}     ${job_name}      ${build_num}
    ${params}       Get Json       ${session}       /job/${job_name}/${build_num}/api/json
    [Return]        ${params}

Get stages
    [Arguments]     ${session}      ${job_name}
    ${stages}       Get Json        ${session}   /job/${job_name}/lastBuild/wfapi
    [Return]        ${stages}
