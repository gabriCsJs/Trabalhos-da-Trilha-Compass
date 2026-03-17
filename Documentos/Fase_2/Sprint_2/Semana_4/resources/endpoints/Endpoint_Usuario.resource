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
Cadastrar Cliente e guardar Id
    [Arguments]    ${nome}=Cliente    ${email}=Cliente@email.com    ${password}=123456    ${administrador}=false    ${Status_Code}=201
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    ${response}=  POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=${Status_Code}

    RETURN   ${response.json()}[_id]  ${Body}[email]  ${Body}[password]

Cadastrar Adm e guardar Id
    [Arguments]    ${nome}=Administrador    ${email}=Administrador@email.com    ${password}=123456    ${administrador}=true    ${Status_Code}=201
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}

    ${response}=  POST On Session  alias=Serverest  url=${ROTA_USUARIOS}    json=&{Body}    expected_status=${Status_Code}
    RETURN   ${response.json()}[_id]  ${Body}[email]  ${Body}[password]

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

