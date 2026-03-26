*** Settings ***
Library  RequestsLibrary
Library  String

*** Variables ***
${ROTA_LOGIN}        /login

*** Keywords ***

Logar no sistema
    [Arguments]  ${email}  ${password}
    &{Body}    Create Dictionary  email=${email}    password=${password}   
    ${response}=  POST On Session  alias=Serverest  url=${ROTA_LOGIN}  json=&{Body}
    RETURN  ${response.json()}[authorization]
    
