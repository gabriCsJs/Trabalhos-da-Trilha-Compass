*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource
Resource    ../keywords/Endpoint_Login.resource

*** Variables ***
${ROTA_USUARIOS}     /usuarios

*** Keywords ***

#-------------Validado-------------#

Cadastrar Usuario estatico valido
    ${json}    importar JSON estatico  resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["usuario_valido"]}
    Cadastrar Usuario    ${body}

Cadastrar usario dinamico valido
    ${payload}    Criar dados para usuarios validos 
    ${id}    ${email}    ${senha}=    Cadastrar Usuario    ${payload}
    RETURN    ${id}    ${email}    ${senha}

Cadastrar Usuario
    [Arguments]    ${body}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=&{Body}
    RETURN    ${response.json()}[_id]    ${body}[email]    ${body}[password]

Editar Usuario    
    [Arguments]    ${id}  ${body}
    ${response}=  PUT On Session   alias=Serverest    url=${ROTA_USUARIOS}/${id}    json=&{Body}
    log   ${response}
    RETURN  ${Body}[email]  ${Body}[password]

Editar usuario Dinamicamente    
    [Arguments]    ${id}
    ${payload}  Criar dados para usuarios validos
    Editar Usuario   ${id}   ${payload}

Excluir Usuario    
    [Arguments]    ${id}
    ${response}=  DELETE On Session  alias=Serverest   url=${ROTA_USUARIOS}/${id}
    log   ${response}

Cadastrar Cliente e administrador
    ${ID_Adm}    ${Email_Adm}    ${Password_Adm}=    Cadastrar usario dinamico valido
    ${ID_Cliente}    ${Email_Cliente}    ${Password_Cliente}=    Cadastrar usario dinamico valido
    ${Adm_authorization}=    Logar no sistema    email=${Email_Adm}    password=${Password_Adm}
    ${Cliente_authorization}=    Logar no sistema        ${Email_Cliente}    ${Password_Cliente}
    ${Adm_Dados}    Create Dictionary    email=${Email_Adm}    password=${Password_Adm}    authorization=${Adm_authorization}
    ${Cliente_Dados}    Create Dictionary    email=${Email_Cliente}    password=${Password_Cliente}    authorization=${Cliente_authorization}
    RETURN    ${Adm_Dados}    ${Cliente_Dados}