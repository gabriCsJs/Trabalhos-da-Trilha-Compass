*** Settings ***
Library    RequestsLibrary
Resource   ../endpoints/Endpoint_Usuario.resource
Resource   ../endpoints/Endpoint_Produtos.resource
Resource   ../endpoints/Endpoint_Login.resource
Resource   ../endpoints/Endpoint_Carrinhos.resource

*** Variables ***
${HOST}    https://compassuol.serverest.dev

${ID_Cliente}
# ${Name_Cliente}
${Password_Cliente}     
${Email_Cliente}
${Cliente_authorization}

${ID_Adm}
# ${Name_Adm}
${Password_Adm}     
${Email_Adm}     
${Adm_authorization}

${ID_Produto}
${ID_Carrinho}

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
    [Documentation]    Cria os usuários Cliente e Administrador e cria um produto 
    ...    ao final dessa execucao nos teremos as credenciais e os IDs de administrador e cliente e o id de um produto 
    #como encontramos pela primeira vez
    Listar Usuarios
    Listar produtos
    Listar carrinhos cadastrados

    ${id_cli}    ${email_cli}    ${senha_cli}=    Cadastrar Usuario    nome=Roberto    email=Roberto11@email.com    password=1234
    Set Suite Variable    ${ID_Cliente}    ${id_cli}
    Set Suite Variable    ${Email_Cliente}    ${email_cli}
    Set Suite Variable    ${Password_Cliente}    ${senha_cli}

    ${id_adm}    ${email_adm}    ${senha_adm}=    Cadastrar Usuario    nome=Administrador   email=Administrador11@gmail.com    password=123456     administrador=true
    Set Suite Variable    ${ID_Adm}        ${id_adm}
    Set Suite Variable    ${Email_Adm}     ${email_adm}
    Set Suite Variable    ${Password_Adm}     ${senha_adm}
    ${adm_authorization}=    Logar no sistema    ${Email_Adm}    ${Password_Adm}
    ${cli_authorization}=    Logar no sistema    ${Email_Cliente}    ${Password_Cliente}
    Set Suite Variable    ${Adm_authorization}    ${adm_authorization}
    Set Suite Variable    ${Cliente_authorization}    ${cli_authorization}
    
    #pegunta para a challange: eu deveria criar um produto aqui na massa de dados? porque eu vou modificar esse produto depois. isso pode confundir alguem?
    ${id_produto}=  Cadastrar produto    ${Adm_authorization}    nome=Cadeira Gamer    preco=5000    descricao=Cadeira    quantidade=1000
    Set Suite Variable    ${ID_Produto}    ${id_produto}
    #como deixamos apos a execucao da massa de dados
    Listar Usuarios
    Listar produtos
    Listar carrinhos cadastrados

Limpar Massa de dados
    [Documentation]    Usa os IDs salvos na suíte para limpar o banco
    Listar Usuarios
    Cancelar compra    ${Cliente_authorization}
    Excluir produto    ${ID_Produto}    ${Adm_authorization}
    Excluir Usuario     ${ID_Adm}
    Excluir Usuario    ${ID_Cliente}
    #como deixamos apos a execucao dos testes e limpeza
    Listar Usuarios
    Listar produtos
    Listar carrinhos cadastrados