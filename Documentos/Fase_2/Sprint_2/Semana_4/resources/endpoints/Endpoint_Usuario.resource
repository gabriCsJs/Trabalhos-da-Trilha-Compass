*** Settings ***
Library  RequestsLibrary
Library  String

*** Variables ***
${ROTA_USUARIOS}     /usuarios

*** Keywords ***

#-------------GET-------------#

Listar Usuarios
    [Arguments]    ${Status_Code}=200
    ${response}=  GET On Session  alias=Serverest   url=${ROTA_USUARIOS}    expected_status=${Status_Code}

Buscar Usuario por ID
    [Arguments]    ${id}    ${Status_Code}=200

    ${response}=  GET On Session   alias=Serverest  url=${ROTA_USUARIOS}/${id}  expected_status=${Status_Code}
    RETURN   ${response.json()}

#-------------POST-------------#
# Cadastrar Usuario
#     [Arguments]    ${nome}=Cliente    ${email}=Cliente@email.com    ${password}=123456  ${administrador}=false   ${Status_Code}=201
    
#     &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
#     ${response}=  POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=${Status_Code}

#     RETURN   ${response.json()}[_id]  ${Body}[email]  ${Body}[password]
Cadastrar Usuario
    [Arguments]    ${nome}=Cliente    ${email}=Cliente@email.com    ${password}=123456    
    ...            ${administrador}=false    ${Status_Code}=201    ${ALEATORIO}=${false}    ${Tamanho}=10
    IF    ${ALEATORIO} == ${true}
        ${nome}               Generate Random String    length=${Tamanho}    chars=[LETTERS]
        ${prefixo_email}      Generate Random String    length=8             chars=[LOWER]
        ${email}              Set Variable              ${prefixo_email}@email.com
        ${password}           Generate Random String    length=6             chars=[NUMBERS]
    END
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=${Body}    expected_status=${Status_Code}

    RETURN    ${response.json()}[_id]    ${Body}[email]    ${Body}[password]
    
#-------------PUT-------------#
Editar Usuario    
    [Arguments]    ${id}    ${nome}=Usuario Editado    ${email}=editado@email.com    ${password}=123456    ${administrador}=false    ${Status_Code}=200
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    
    ${response}=  PUT On Session   alias=Serverest    url=${ROTA_USUARIOS}/${id}    json=&{Body}    expected_status=${Status_Code}
    RETURN  ${Body}[email]  ${Body}[password]

#-------------DELETE-------------#
Excluir Usuario    
    [Arguments]    ${id}    ${Status_Code}=200

    ${response}=  DELETE On Session  alias=Serverest   url=${ROTA_USUARIOS}/${id}    expected_status=${Status_Code}

