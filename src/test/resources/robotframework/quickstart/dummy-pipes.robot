| *** Settings ***   |
| Documentation      | Example using the pipe separated plain text format.
| Library            | OperatingSystem
| Library            | Process
| Library            | String
| Library            | DateTime

| *** Variables ***  |
| ${MESSAGE}         | Hello, world!

| *** Test Cases *** |                 |              |
| My Test            | [Documentation] | Example test |
|                    | Log             | ${MESSAGE}   |
|                    | My Keyword      | /            |
| Another Test       | Should Be Equal | ${MESSAGE}   | Hello, world!

| *** Keywords ***   |                        |         |
| My Keyword         | [Arguments]            | ${path} |
|                    | Directory Should Exist | ${path} |
