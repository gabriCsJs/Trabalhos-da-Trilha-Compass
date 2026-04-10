*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource

*** Variables ***

# Mensagens esperadas
${MSG_CADASTRO_SUCESSO}              Cadastro realizado com sucesso
${MSG_EMAIL_DUPLICADO}               Este email já está sendo usado
${MSG_REGISTRO_ALTERADO}             Registro alterado com sucesso
${MSG_REGISTRO_EXCLUIDO}             Registro excluído com sucesso
${MSG_NENHUM_REGISTRO_EXCLUIDO}      Nenhum registro excluído
${MSG_USUARIO_COM_CARRINHO}          Não é permitido excluir usuário com carrinho cadastrado
${MSG_LOGIN_SUCESSO}                 Login realizado com sucesso
${MSG_LOGIN_INVALIDO}                Email e/ou senha inválidos
*** Keywords ***


Cadastrar Usuario estatico valido
    [Arguments]    ${cenario}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["validos"]["${cenario}"]}
    ${id}    ${email}    ${senha}  ${mensagem}=  Post    ${ROTA_USUARIOS}    ${body}    201
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}
    RETURN    ${id}    ${email}    ${senha}

Falhar em cadastrar usuario: campo extra
    [Arguments]    ${cenario}=campo_extra
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["invalidos"]["${cenario}"]}
    ${resultado}=    Validar campos do payload de usuario    ${body}
    Should Start With    ${resultado}    campo_extra:
    ${campo}=    Set Variable    ${resultado.split(":")[1]}
    ${resposta}=    Post    ${ROTA_USUARIOS}    ${body}    400
    Should Be Equal    ${resposta["${campo}"]}    ${campo} não é permitido

Falhar em cadastrar usuario: campo faltando
    [Arguments]    ${cenario}=sem_campo_email
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/usuarios.json
    ${body}    Set Variable    ${json["invalidos"]["${cenario}"]}
    ${resultado}=    Validar campos do payload de usuario    ${body}
    Should Start With    ${resultado}    campo_faltando:
    ${campo}=    Set Variable    ${resultado.split(":")[1]}
    ${resposta}=    Post    ${ROTA_USUARIOS}    ${body}    400
    Should Be Equal    ${resposta["${campo}"]}    ${campo} é obrigatório

Cadastrar Usuario dinamico valido
    [Arguments]    ${retorno?}=${True}
    ${payload}    Criar dados para usuarios validos 
    ${id}    ${email}    ${senha}  ${mensagem}=    Post    ${ROTA_USUARIOS}    ${payload}    201 
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}
    IF    ${retorno?}==${True}
        RETURN    ${id}    ${email}    ${senha}
    END

Falhar em cadastrar usuario com email ja cadastrado Pelo POST
    ${id}    ${Email}    ${Password}=    Cadastrar Usuario dinamico valido
    &{playload}    Create Dictionary    nome=fulano    email=${email}    password=${Password}    administrador=true
    ${mensagem}=  Post    ${ROTA_USUARIOS}    ${playload}    400
    Should Be Equal    ${mensagem}   ${MSG_EMAIL_DUPLICADO}

Editar usuario Dinamicamente Com sucesso
    [Arguments]    ${id}   
    ${payload}  Criar dados para usuarios validos
    ${mensagem}=  Put     ${ROTA_USUARIOS}   ${id}   ${payload}    200
    Should Be Equal    ${mensagem}   ${MSG_REGISTRO_ALTERADO}

Criar usuario Dinamicamente pelo PUT com sucesso
    ${id}=   Gerar id alfanumerico
    ${payload}  Criar dados para usuarios validos
    ${id}   ${mensagem}=  Put     ${ROTA_USUARIOS}   ${id}   ${payload}    201
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}
falhar em cadastrar um usuario pelo put com um email ja cadastrado
    ${id}    ${Email}    ${Password}=    Cadastrar Usuario dinamico valido
    ${id_falso}=    Gerar id alfanumerico
    &{playload}    Create Dictionary    nome=fulano    email=${email}    password=${Password}    administrador=true
    ${mensagem}=  Put    ${ROTA_USUARIOS}  ${id_falso}  ${playload}    400
    Should Be Equal    ${mensagem}   ${MSG_EMAIL_DUPLICADO}
Excluir Usuario com sucesso
    [Arguments]    ${id}
    ${mensagem}=  Delete    ${ROTA_USUARIOS}    ${id}    200
    Should Be Equal    ${mensagem}   ${MSG_REGISTRO_EXCLUIDO}

Excluir usuario que nao existe
    ${id}=    Gerar id alfanumerico
    ${mensagem}=  Delete    ${ROTA_USUARIOS}     ${id}    200
    Should Be Equal    ${mensagem}   ${MSG_NENHUM_REGISTRO_EXCLUIDO}

Falhar em excluir usuario com carrinho cadastrado
    [Arguments]    ${id}
    ${id_do_carrinho}  ${mensagem}=    Delete    ${ROTA_USUARIOS}    ${id}    400
    Should Be Equal    ${mensagem}    ${MSG_USUARIO_COM_CARRINHO}

Cadastrar Cliente e administrador
    ${local_ID_Adm}    ${local_Email_Adm}    ${local_Password_Adm}=    Cadastrar Usuario dinamico valido
    ${local_ID_Cliente}    ${local_Email_Cliente}    ${local_Password_Cliente}=    Cadastrar Usuario dinamico valido
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
    ${authorization}    ${mensagem}=  Post  ${ROTA_LOGIN}    ${Body}    200
    Should Be Equal    ${mensagem}   ${MSG_LOGIN_SUCESSO}
    RETURN    ${authorization}

Falhar em logar: Senha errada
    ${id}    ${email}    ${senha}=    Cadastrar Usuario dinamico valido
    ${senha}=    Gerar Senha aleatoria
    &{Body}    Create Dictionary  email=${email}    password=${senha}
    ${mensagem}=  Post  ${ROTA_LOGIN}    ${Body}    401
    Should Be Equal    ${mensagem}   ${MSG_LOGIN_INVALIDO}
    Excluir Usuario com sucesso    ${id}

Falhar em logar: Senha Com letra maiusculas
    ${id}    ${email}    ${senha}=    Cadastrar Usuario dinamico valido
    ${senha}=    Convert To Upper Case    ${senha}
    &{Body}    Create Dictionary  email=${email}    password=${senha}
    ${mensagem}=  Post  ${ROTA_LOGIN}    ${Body}    401
    Should Be Equal    ${mensagem}   ${MSG_LOGIN_INVALIDO}
    Excluir Usuario com sucesso    ${id}

Falhar em logar: Email errado
    ${email}=    Gerar email aleatorio valido
    &{Body}    Create Dictionary  email=${email}    password=11111
    ${mensagem}=  Post  ${ROTA_LOGIN}    ${Body}    401
    Should Be Equal    ${mensagem}   ${MSG_LOGIN_INVALIDO}

Falhar em logar: email e senha errados
    ${senha}=    Gerar Senha aleatoria
    ${email}=    Gerar email aleatorio valido
    &{Body}    Create Dictionary  email=${email}    password=${senha}
    ${mensagem}=  Post  ${ROTA_LOGIN}  ${Body}    401
    Should Be Equal    ${mensagem}   ${MSG_LOGIN_INVALIDO}

Excluir um usuario sem carrinho com sucesso
    ${id}  ${email}  ${senha}=    Cadastrar Usuario dinamico valido
    Excluir Usuario com sucesso   ${id}
Criar e Editar um usuario com sucesso
    ${id}  ${email}  ${senha}=    Cadastrar Usuario dinamico valido
    Editar usuario Dinamicamente Com sucesso    ${id}
