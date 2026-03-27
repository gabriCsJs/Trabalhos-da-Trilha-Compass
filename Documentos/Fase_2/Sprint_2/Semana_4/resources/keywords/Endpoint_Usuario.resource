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
    [Arguments]    ${cenario}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["validos"]["${cenario}"]}
    ${id}    ${email}    ${senha}  ${mensagem}=  Post Usuario    ${body}   201

    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
    RETURN    ${id}    ${email}    ${senha}


Cadastrar usario dinamico valido
    ${payload}    Criar dados para usuarios validos 
    ${id}    ${email}    ${senha}  ${mensagem}=    Post Usuario    ${payload}    201
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
    RETURN    ${id}    ${email}    ${senha}

Falhar em cadastrar usario com email ja cadastrado
    ${id}    ${Email}    ${Password}=    Cadastrar Usuario estatico valido    cenario=Cliente
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["validos"]["Cliente"]}
    ${id}    ${email}    ${senha}  ${mensagem}=  Post Usuario    ${body}    400
    Should Be Equal    ${mensagem}   Este email já está sendo usado


Post Usuario
    [Arguments]    ${body}    ${statuscode}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=${statuscode}
    RETURN    ${response.json()}[_id]    ${body}[email]    ${body}[password]   ${response.json()}[message]

Put Usuario   
    [Arguments]    ${id}  ${body}    ${stuatuscode}
    ${response}=  PUT On Session   alias=Serverest    url=${ROTA_USUARIOS}/${id}    json=&{Body}    expected_status=${stuatuscode}
    log   ${response}
    # RETURN  ${Body}[email]  ${Body}[password]

Editar usuario Dinamicamente
    [Arguments]    ${id}    ${statuscode}=200
    ${payload}  Criar dados para usuarios validos
    Put Usuario   ${id}   ${payload}    ${statuscode}

Criar usario Dinamicamente pelo PUT com sucesso
    [Arguments]    ${id}      
    Editar usuario Dinamicamente    ${id}    201

Excluir Usuario Com suscesso
    [Arguments]    ${id}
    ${response}=    DELETE On Session    alias=Serverest    url=${ROTA_USUARIOS}/${id}    expected_status=200
    Should Be Equal    ${response.json()}[message]    Registro excluído com sucesso
    # Log    ${response.json()}

Falhar em excluir usuario
    [Arguments]    ${id}
    ${response}=    DELETE On Session    alias=Serverest    url=${ROTA_USUARIOS}/${id}    expected_status=400
    Should Be Equal    ${response.json()}[message]    Não é permitido excluir usuário com carrinho cadastrado

Cadastrar Cliente e administrador
    ${local_ID_Adm}    ${local_Email_Adm}    ${local_Password_Adm}=    Cadastrar usario dinamico valido
    ${local_ID_Cliente}    ${local_Email_Cliente}    ${local_Password_Cliente}=    Cadastrar usario dinamico valido
    ${local_Adm_auth}=       Logar no sistema    ${local_Email_Adm}       ${local_Password_Adm}
    ${local_Cliente_auth}=   Logar no sistema    ${local_Email_Cliente}   ${local_Password_Cliente}

    Set Global Variable    ${ID_Adm}                    ${local_ID_Adm}
    Set Global Variable    ${Email_Adm}                 ${local_Email_Adm}
    Set Global Variable    ${Password_Adm}              ${local_Password_Adm}
    Set Global Variable    ${Adm_authorization}         ${local_Adm_auth}

    Set Global Variable    ${ID_Cliente}                ${local_ID_Cliente}
    Set Global Variable    ${Email_Cliente}             ${local_Email_Cliente}
    Set Global Variable    ${Password_Cliente}          ${local_Password_Cliente}
    Set Global Variable    ${Cliente_authorization}     ${local_Cliente_auth}
