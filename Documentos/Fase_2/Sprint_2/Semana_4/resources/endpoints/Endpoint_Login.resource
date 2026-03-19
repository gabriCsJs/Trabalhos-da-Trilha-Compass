*** Settings ***
Library  RequestsLibrary
Library  String

*** Variables ***
${ROTA_LOGIN}        /login

*** Keywords ***

Logar no sistema
    [Arguments]  ${email}  ${password}  ${Status_Code}=200

    &{Body}    Create Dictionary  email=${email}    password=${password}   

    ${response}=  POST On Session  alias=Serverest  url=${ROTA_LOGIN}  json=&{Body}  expected_status=${Status_Code}
    IF    ${Status_Code}==200
            RETURN  ${response.json()}[authorization]
    END
    
