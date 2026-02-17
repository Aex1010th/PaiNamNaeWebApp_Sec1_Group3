*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***
${BASE_URL}       http://localhost:3000
${SESSION}        api

*** Test Cases ***
Register API Test
    Create Session    ${SESSION}    ${BASE_URL}
    ${email}    ${password}=    Create Account
    Delete All Sessions

Login API Test
    Create Session    ${SESSION}    ${BASE_URL}
    ${email}    ${password}=    Create Account
    ${token}=    Login Account    ${email}    ${password}
    Should Not Be Empty    ${token}
    Delete All Sessions

Delete API Test
    Create Session    ${SESSION}    ${BASE_URL}
    ${email}    ${password}=    Create Account
    ${token}=    Login Account    ${email}    ${password}
    Delete Account    ${token}    ${password}
    Login Should Fail    ${email}    ${password}
    Delete All Sessions
    
*** Keywords ***
Generate Random Data
    ${rand}=    Evaluate    random.randint(100000,999999)    modules=random
    ${nid}=     Evaluate    ''.join(random.choices('0123456789', k=13))    modules=random
    RETURN    ${rand}    ${nid}

Create Account
    ${rand}    ${nid}=    Generate Random Data
    ${USERNAME}=    Set Variable    user${rand}
    ${EMAIL}=       Set Variable    test${rand}@gmail.com
    ${PASSWORD}=    Set Variable    12345678
    ${national_file}=    Get Binary File    ${CURDIR}/files/national.jpg
    ${national_list}=    Create List    national.jpg    ${national_file}    image/jpeg

    &{files}=    Create Dictionary
    ...    nationalIdPhotoUrl=${national_list}
    ...    selfiePhotoUrl=${national_list}


    &{form}=    Create Dictionary
    ...    username=${USERNAME}
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    ...    firstName=test
    ...    lastName=user
    ...    gender=MALE
    ...    phoneNumber=0656587417
    ...    nationalIdNumber=${nid}
    ...    nationalIdExpiryDate=2026-12-31T00:00:00.000Z

    ${response}=    POST On Session
    ...    ${SESSION}
    ...    /api/users
    ...    data=${form}
    ...    files=${files}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    201
    ${json}=    Set Variable    ${response.json()}
    Should Be True    ${json["success"]}
    RETURN    ${EMAIL}    ${PASSWORD}

Login Account
    [Arguments]    ${email}    ${password}

    &{login_body}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}

    ${response}=    POST On Session
    ...    ${SESSION}
    ...    /api/auth/login
    ...    json=${login_body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be True    ${json["success"]}
    RETURN    ${json["data"]["token"]}

Delete Account
    [Arguments]    ${token}    ${password}
    &{headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    &{delete_body}=    Create Dictionary
    ...    password=${password}

    ${response}=    DELETE On Session
    ...    ${SESSION}
    ...    /api/users/me
    ...    headers=${headers}
    ...    json=${delete_body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be True    ${json["success"]}

Login Should Fail
    [Arguments]    ${email}    ${password}

    &{login_body}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}

    ${response}=    POST On Session
    ...    ${SESSION}
    ...    /api/auth/login
    ...    json=${login_body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    401
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json["success"]}    ${False}
