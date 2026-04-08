*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource

*** Variables ***
${ROTA_USUARIOS}     /usuarios
${ROTA_LOGIN}        /login

*** Keywords ***

#-------------Só pensei nessas keywords, agora devemos validar se elas estao funcionando-------------#

Cadastrar Usuario estatico valido
    [Arguments]    ${cenario}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["validos"]["${cenario}"]}
    ${id}    ${email}    ${senha}  ${mensagem}=  Post Usuario    ${body}   201

    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
    RETURN    ${id}    ${email}    ${senha}

Cadastrar Usario dinamico valido
    [Arguments]    ${retorno?}=${True}
    ${payload}    Criar dados para usuarios validos 
    ${id}    ${email}    ${senha}  ${mensagem}=    Post Usuario    ${payload}    201
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
    IF    ${retorno?}==${True}
        RETURN    ${id}    ${email}    ${senha}
    END

Falhar em cadastrar usario com email ja cadastrado
    ${id}    ${Email}    ${Password}=    Cadastrar Usuario estatico valido    cenario=Cliente
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["validos"]["Cliente"]}
    ${mensagem}=  Post Usuario    ${body}    400
    Should Be Equal    ${mensagem}   Este email já está sendo usado

Post Usuario
    [Arguments]    ${body}    ${statuscode}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=${statuscode}
    IF    ${statuscode}==201
        RETURN    ${response.json()}[_id]    ${body}[email]    ${body}[password]   ${response.json()}[message]
        ELSE
        RETURN    ${response.json()}[message]
    END
    
    
Put Usuario   
    [Arguments]    ${id}  ${body}    ${stuatuscode}
    ${response}=  PUT On Session   alias=Serverest    url=${ROTA_USUARIOS}/${id}    json=&{Body}    expected_status=${stuatuscode}
    log   ${response}
    IF    ${stuatuscode}==201
        RETURN    ${response.json()}[_id]    ${response.json()}[message]
    ELSE
        RETURN    ${response.json()}[message]
    END
    
    # RETURN  ${Body}[email]  ${Body}[password]

Delete Usuario
    [Arguments]    ${id}    ${stuatuscode}
    ${response}=    DELETE On Session    alias=Serverest    url=${ROTA_USUARIOS}/${id}    expected_status=${stuatuscode}
    IF    ${stuatuscode}==400
        RETURN    ${response.json()}[idCarrinho]  ${response.json()}[message]
    ELSE
        RETURN    ${response.json()}[message]
    END

Editar usuario Dinamicamente Com sucesso
    [Arguments]    ${id}   
    ${payload}  Criar dados para usuarios validos
    ${mensagem}=  Put Usuario   ${id}   ${payload}    200
    Should Be Equal    ${mensagem}   Registro alterado com sucesso

Criar usario Dinamicamente pelo PUT com sucesso
    ${id}=   Gerar id alfanumerico
    ${payload}  Criar dados para usuarios validos
    ${id}   ${mensagem}=  Put Usuario   ${id}   ${payload}    201
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso

Excluir Usuario com sucesso
    [Arguments]    ${id}
    ${mensagem}=  Delete Usuario    ${id}    200
    Should Be Equal    ${mensagem}   Registro excluído com sucesso


Excluir usuario que nao existe
    ${id}=    Gerar id alfanumerico
    ${mensagem}=  Delete Usuario    ${id}    200
    Should Be Equal    ${mensagem}   Nenhum registro excluído

Falhar em excluir usuario com carrinho cadastrado
    [Arguments]    ${id}
    ${id_do_carrinho}  ${mensagem}=    Delete Usuario    ${id}    400
    Should Be Equal    ${mensagem}    Não é permitido excluir usuário com carrinho cadastrado

Cadastrar Cliente e administrador
    ${local_ID_Adm}    ${local_Email_Adm}    ${local_Password_Adm}=    Cadastrar Usario dinamico valido
    ${local_ID_Cliente}    ${local_Email_Cliente}    ${local_Password_Cliente}=    Cadastrar Usario dinamico valido
    ${local_Adm_auth}=       Logar no sistema Com sucesso   ${local_Email_Adm}       ${local_Password_Adm}
    ${local_Cliente_auth}=   Logar no sistema Com sucesso   ${local_Email_Cliente}   ${local_Password_Cliente}

    Set Global Variable    ${ID_Adm}                    ${local_ID_Adm}
    Set Global Variable    ${Email_Adm}                 ${local_Email_Adm}
    Set Global Variable    ${Password_Adm}              ${local_Password_Adm}
    Set Global Variable    ${Adm_authorization}         ${local_Adm_auth}

    Set Global Variable    ${ID_Cliente}                ${local_ID_Cliente}
    Set Global Variable    ${Email_Cliente}             ${local_Email_Cliente}
    Set Global Variable    ${Password_Cliente}          ${local_Password_Cliente}
    Set Global Variable    ${Cliente_authorization}     ${local_Cliente_auth}
Deletar Cliente e administrador
    Excluir Usuario com sucesso   ${ID_Adm}
    Excluir Usuario com sucesso    ${ID_Cliente}
    



Logar no sistema Com sucesso
    [Arguments]  ${email}  ${password}    
    &{Body}    Create Dictionary  email=${email}    password=${password}
    ${authorization}    ${mensagem}=  Post Login    ${Body}    200
    Should Be Equal    ${mensagem}   Login realizado com sucesso
    RETURN    ${authorization}

Falhar em logar: Senha errada
    [Arguments]    ${email}
    ${senha}=    Gerar Senha aleatoria
    &{Body}    Create Dictionary  email=${email}    password=${senha}
    ${mensagem}=  Post Login    ${Body}    401
    Should Be Equal    ${mensagem}   Email e/ou senha inválidos

Falhar em logar: Email errado
    ${email}=    Gerar email aleatorio valido
    &{Body}    Create Dictionary  email=${email}    password=11111
    ${mensagem}=  Post Login    ${Body}    401
    Should Be Equal    ${mensagem}   Email e/ou senha inválidos

Post Login
    [Arguments]  ${body}    ${statuscode}  
    ${response}=  POST On Session  alias=Serverest  url=${ROTA_LOGIN}  json=&{Body}
    IF    ${statuscode}==200
        RETURN  ${response.json()}[authorization]    ${response.json()}[message]
    ELSE
        RETURN  ${response.json()}[message]
    END
    
    
Falhar em logar: email e senha errados
    ${senha}=    Gerar Senha aleatoria
    ${email}=    Gerar email aleatorio valido
    &{Body}    Create Dictionary  email=${email}    password=${senha}
    ${mensagem}=  Post Login    ${Body}    401
    Should Be Equal    ${mensagem}   Email e/ou senha inválidos







Excluir um usuario sem carrinho com sucesso
    ${id}  ${email}  ${senha}=    Cadastrar Usario dinamico valido
    Excluir Usuario com sucesso   ${id}
Criar e Editar um usuario com sucesso
    ${id}  ${email}  ${senha}=    Cadastrar Usario dinamico valido
    Editar usuario Dinamicamente Com sucesso    ${id}