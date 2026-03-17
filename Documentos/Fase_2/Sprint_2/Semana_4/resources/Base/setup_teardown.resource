*** Settings ***
Library    RequestsLibrary
Resource   ../endpoints/Endpoint_Usuario.resource
Resource   ../endpoints/Endpoint_Produtos.resource
Resource   ../endpoints/Endpoint_Login.resource
Resource   ../endpoints/Endpoint_Carrinhos.resource

*** Variables ***
${HOST}    https://compassuol.serverest.dev

${ID_Cliente}       
${Password_Cliente}     
${Email_Cliente}

${ID_Adm}
${Password_Adm}     
${Email_Adm}     

${ID_Produto}
${ID_Carrinho}

${Cliente_authorization}
${Adm_authorization}


*** Keywords ***
Iniciar Sessao API
    [Documentation]    Cria a sessão principal da Serverest
    Create Session    alias=Serverest    url=${HOST}    disable_warnings=True

Encerrar Sessao API
    Delete All Sessions

# Criar Massa de Dados da Suite
#     [Documentation]    Keyword agrupadora para o Suite Setup
#     ${id_cliente}=  POST - Cadastrar Cliente e guardar Id
#     ${id_Adm}=  POST - Cadastrar Adm e guardar Id
# Limpar Massa de dados
#     DELETE - Excluir Usuario Sem carrinho  ${id_Adm}
#     DELETE - Excluir Usuario Sem carrinho  ${id_cliente}

Criar Massa de Dados da Suite
    [Documentation]    Cria os usuários Cliente e Administrador e cria o Produto
    

    ${id_cli}    ${email_cli}    ${senha_cli}=    Cadastrar Cliente e guardar Id
    Set Suite Variable    ${ID_Cliente}    ${id_cli}
    Set Suite Variable    ${Email_Cliente}    ${email_cli}
    Set Suite Variable    ${Password_Cliente}    ${senha_cli}

    ${id_adm}    ${email_adm}    ${senha_adm}=    Cadastrar Adm e guardar Id
    Set Suite Variable    ${ID_Adm}        ${id_adm}
    Set Suite Variable    ${Email_Adm}     ${email_adm}
    Set Suite Variable    ${Password_Adm}     ${senha_adm}
    ${Adm_authorization}=    Logar no sistema    ${Email_Adm}    ${Password_Adm}
    ${Cliente_authorization}=    Logar no sistema    ${Email_Cliente}    ${Password_Adm}

    ${ID_Produto}=  Cadastrar produto    ${Adm_authorization}
    Listar Usuarios

Limpar Massa de dados
    [Documentation]    Usa os IDs salvos na suíte para limpar o banco
    Listar Usuarios
    Excluir Usuario     ${ID_Adm}
    Excluir Usuario    ${ID_Cliente}
    Listar Usuarios