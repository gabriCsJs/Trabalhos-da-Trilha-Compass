*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${HOST}  https://compassuol.serverest.dev

##-------------CREDENCIAIS E UTILITARIOS-------------#
${ID_Cliente}        
${Senha_Cliente}
${Email_Cliente}

${ID_Adm}
${Senha_Adm}     
${Email_Adm}     

${ID_Produto}
${ID_Carrinho}

${authorization}
#-------------ROTAS-------------#
#Login
${ROTA_LOGIN}                       ${HOST}/login

#Usuarios
${ROTA_USUARIOS}                    ${HOST}/usuarios


#Produtos
${ROTA_PRODUTOS}                    ${HOST}/produtos

#Carrinhos
${ROTA_CARRINHOS}                 ${HOST}/carrinhos
${ROTA_CONCLUIR_COMPRA}           ${HOST}/carrinhos/concluir-compra
${ROTA_CANCELAR_COMPRA}           ${HOST}/carrinhos/cancelar-compra

*** Keywords ***

Criar Massa de Dados da Suite
    [Documentation]    Keyword agrupadora para o Suite Setup
    POST - Cadastrar Cliente e guardar Id
    POST - Cadastrar Adm e guardar Id
Limpar Massa de dados
    DELETE - Excluir Usuario Sem carrinho  ${ID_Adm}
    DELETE - Excluir Usuario Sem carrinho  ${ID_Cliente}

#-------------ENDPOINT USUARIOS-------------#

#Keywords para criar com sucesso

GET - Listar Usuarios

    Get  url=${ROTA_USUARIOS}

POST - Cadastrar Cliente e guardar Id
    [Arguments]    ${nome}=Cliente    ${email}=Cliente@email.com    ${password}=123456    ${administrador}=false
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}

    ${response}=  POST    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=201
    Set Global Variable    ${ID_Cliente}    ${response.json()}[_id]
    Set Global Variable    ${Email_Cliente}    ${Body}[email]
    Set Global Variable    ${Senha_Cliente}    ${Body}[password]
    
    Log    O ID do usuário cadastrado é: ${ID_Cliente}
    Log    O ID do usuário cadastrado é: ${Email_Cliente}
    Log    O ID do usuário cadastrado é: ${Senha_Cliente}

POST - Cadastrar Adm e guardar Id
    [Arguments]    ${nome}=Administrador    ${email}=Administrador@email.com    ${password}=123456    ${administrador}=true
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}

    ${response}=  POST    url=${ROTA_USUARIOS}    json=&{Body}    expected_status=201
    Set Global Variable    ${ID_Adm}    ${response.json()}[_id]
    Set Global Variable    ${Email_Adm}    ${Body}[email]
    Set Global Variable    ${Senha_Adm}    ${Body}[password]

    Log    O ID do usuário cadastrado é: ${ID_Adm}
    Log    O ID do usuário cadastrado é: ${Email_Adm}
    Log    O ID do usuário cadastrado é: ${Senha_Adm}

GET - Buscar Usuario por ID
    [Arguments]    ${id}

    ${response}=  Get  url=${ROTA_USUARIOS}/${id}    expected_status=200
    Log    Os dados do usuario sao: ${response.json()}



DELETE - Excluir Usuario Sem carrinho
    [Arguments]    ${id}

    ${response}=  DELETE    url=${ROTA_USUARIOS}/${id}    expected_status=200

DELETE - Falhar em Excluir Usuario Com carrinho
    [Arguments]    ${id}

    ${response}=  DELETE    url=${ROTA_USUARIOS}/${id}    expected_status=400

PUT - Editar Usuario
    [Arguments]    ${id}    ${nome}=Usuario Editado    ${email}=editado@email.com    ${password}=123456    ${administrador}=false
    
    &{Body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    
    ${response}=  PUT    url=${ROTA_USUARIOS}/${id}    json=&{Body}    expected_status=200


#Keywords para criar com dados defeituosos/inesperados

#-------------ENDPOINT PRODUTOS-------------#

#Keywords para criar com sucesso

Cadastrar Produto
    &{Header}  Create Dictionary  Authorization=${authorization}
    #POST + alguma coisa + headers=&{Header}

#Keywords para criar com dados defeituosos/inesperados



#-------------ENDPOINT CARRINHO-------------#

#Keywords para criar com sucesso
#Keywords para criar com dados defeituosos/inesperados

#-------------ENDPOINT LOGIN-------------#

#Keywords para criar com sucesso
#Keywords para criar com dados defeituosos/inesperados