*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup     Iniciar Sessao API
Suite Teardown   Encerrar Sessao API

*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-02-User-Delete
    [Documentation]    deleta um usuário sem carrinho ativo com sucesso
    [Tags]    Positivo
    Excluir um usuario sem carrinho com sucesso
CT-Pos-03-User-Delete
    [Documentation]    Gerar ID e enviar uma requisiçao para a api deletar o usuario
    [Tags]    Positivo
    Excluir usuario que nao existe
CT-Pos-04-User-Put
    [Documentation]    Gerar ID e enviar uma requisiçao para a api deletar o usuario
    [Tags]    Positivo
    Criar e Editar um usuario com sucesso
CT-Pos-14-User-Post
    [Documentation]    Criar usuario com sucesso
    [Tags]    Positivo
    ${id}  ${email}  ${senha}=  Cadastrar Usario dinamico valido
    Excluir Usuario com sucesso    ${id}
#---------------NEGATIVOS----------------#
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#