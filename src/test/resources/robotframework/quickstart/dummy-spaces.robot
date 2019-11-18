*** Settings ***
Documentation    Example using the space separated plain text format.
Library          OperatingSystem
#Library          com.github.vtitov.testing.jenkins.robot.SimpleHttpServer WITH NAME SimpleHttpServer
#Library          com.github.vtitov.testing.jenkins.robot.SunHttpTestServer  8080  /java     WITH NAME  SimpleHttpServer
Library         com.github.vtitov.testing.jenkins.robot.SunHttpServer   WITH NAME   SunHttpServer
Library         com.github.vtitov.testing.jenkins.robot.LoremIpsum      # 5873663672292697529 # <- seed
Library         HttpRequestLibrary
Library         SeleniumLibrary
Library         DatabaseLibrary
Library         Process
Suite Setup       Start H2 server
Suite Teardown    Stop H2 Server


*** Variables ***
${MESSAGE}       Hello, world!
${URL_PATH}       /java
#${browser}    jbrowser
${browser}    htmlunit


*** Test Cases ***
Keyword Test
    [Documentation]    Example test
    Log    ${MESSAGE}
    My Keyword    /

String Test
    Should Be Equal    ${MESSAGE}    Hello, world!


Lorem Seed Test
    ${seed}             Get Seed
    Log                 lorem seed ${seed}

Lorem Phone Test
    ${phone}            Get Phone
    Length Should Be    ${phone}    14

Lorem Zip Test
    ${zip}              Get Zip Code
    Length Should Be    ${zip}      5


HTTP Test
    [Documentation]     Http Test
    ${SERVER} =                     Create Http Server  0   ${URL_PATH}
    Http Server Info                ${SERVER}
    ${SERVER_URL} =                 Http Server URL  ${SERVER}
    ${RESOURCE_URL}                 Catenate	SEPARATOR=     ${SERVER_URL}    ${URL_PATH}
    Log                             REST test
    Create Session                  google    ${SERVER_URL}
    ${resp}                         Get Request    google    /java
    Should Be Equal As Strings      ${resp.status_code}    200
    Should Be Equal As Strings      ${resp.content}    duke

Create Test Table
    [Documentation]    Creates the test table used for testing throughout the demo.
    Execute SQL    CREATE TABLE DemoTable (Id INT NOT NULL, Name VARCHAR(255))
    Execute SQL    ALTER TABLE DemoTable ADD PRIMARY KEY (Id);
    Table Must Exist    DEMOTABLE
    Table Must Be Empty    DEMOTABLE
    Check Primary Key Columns For Table    DEMOTABLE    Id

Open Browser
    [Documentation]                 Browser test
    ${SERVER} =                     Create Http Server  0   ${URL_PATH}
    Http Server Info                ${SERVER}
    ${SERVER_URL} =                 Http Server URL  ${SERVER}
    ${RESOURCE_URL}                 Catenate	SEPARATOR=     ${SERVER_URL}    ${URL_PATH}
    Open Browser                    ${RESOURCE_URL}    ${browser}
    Capture Page Screenshot
#    Open Browser    https://www.google.com    ${browser}
#    Capture Page Screenshot


*** Keywords ***
My Keyword
    [Arguments]    ${path}
    Directory Should Exist    ${path}

Start H2 server
    Start Process           java    -cp    ${maven_test_classpath}    org.h2.tools.Server    -tcp    -tcpAllowOthers
    Connect To Database    org.h2.Driver    jdbc:h2:mem:robotDummyTest;DB_CLOSE_DELAY=-1    sa    ${EMPTY}

Stop H2 server
    Disconnect From Database
    Run Process             java    -cp    ${maven_test_classpath}    org.h2.tools.Server    -tcpShutdown    tcp://localhost:9092
