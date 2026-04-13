*** Settings ***
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource

Test Setup   Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
test Teardown   Run Keywords  Deletar Cliente e administrador    AND      Encerrar Sessao API
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
    Falhar em Excluir produto: Produto inexistente
CT-Pos-08-Produto-Put
    [Documentation]    editar um produto que já existe
    [Tags]    Positivo
    Criar e editar produto
CT-Pos-09-Produto-Put
    [Documentation]    tentar criar um produto que não existe pelo put
    [Tags]    Positivo
    Criar produto Dinamicamente pelo PUT Com sucesso
#---------------NEGATIVOS----------------#
Ct-Neg-07-Produto-Post
    [Documentation]    Tentar criar um produto com um token de autorização gerado artificialmente
    [Tags]    Negativo
    Falhar em Criar produto: authorization gerada artificialmente
Ct-Neg-08-Produto-Delete
    [Documentation]    Tentar deletar um produto que faz parte de um carrinho
    [Tags]    Negativo
    Cadastrar produto dinamico valido    ${Adm_authorization}
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}    
    Falhar em excluir produto: Produto faz parte de um carrinho    ${Adm_authorization}    ${ID_Produto}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}
    Excluir produto com sucesso: Produto existente
Ct-Neg-09-Produto-Delete
    [Documentation]    Gere um token falso e tente excluir o produto
    [Tags]    Negativo
    Falhar em excluir produto: authorization invalida
Ct-Neg-10-Produto-PUT
    [Documentation]   tente criar um produto com um nome de um produto ja registrado
    [Tags]    Negativo
    Falhar em criar produto pelo PUT: nome de produto ja registrado
Ct-Neg-11-Produto-PUT
    [Documentation]    logue com um usuário com privilégios administrativos e espero o tempo de expiração do token e tente editar um produto
    [Tags]    Negativo
    Falhar em editar produto: authorization expirada
Ct-Neg-12-Produto-PUT
    [Documentation]   gere um token artificial e tente editar um produto
    [Tags]    Negativo
    Falhar em editar produto: authorization invalida
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#