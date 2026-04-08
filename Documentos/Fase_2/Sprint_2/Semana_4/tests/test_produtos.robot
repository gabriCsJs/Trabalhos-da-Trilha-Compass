*** Settings ***
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
Suite Teardown   Run Keywords   Encerrar Sessao API  AND    Deletar Cliente e administrador 

*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-05-Produto-Post
    [Documentation]    criar um produto válido
    [Tags]    Positivo
    Cadastrar produto dinamico valido
    Excluir produto com sucesso: Produto existente
CT-Pos-06-Produto-Post
    [Documentation]    Tentar deletar um produto que não faz parte de um carrinho
    [Tags]    Positivo
    Cadastrar produto dinamico valido
    Excluir produto com sucesso: Produto existente
CT-Pos-07-Produto-Delete
    [Documentation]    Gerar um ID e tentar deletar este produto que nao existe
    [Tags]    Positivo
    Excluir produto: Produto inexistente
CT-Pos-08-Produto-Put
    [Documentation]    editar um produto que já existe
    [Tags]    Positivo
    Criar e editar produto
CT-Pos-09-Produto-Put
    [Documentation]    tentar criar um produto que não existe pelo put
    [Tags]    Positivo
    Criar produto Dinamicamente pelo PUT Com sucesso


#---------------NEGATIVOS----------------#
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#