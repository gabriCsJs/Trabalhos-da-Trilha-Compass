*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource

Test Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador  AND  Cadastrar produto dinamico valido
Test Teardown   Run Keywords   Excluir produto com sucesso: Produto existente   AND    Deletar Cliente e administrador  AND   Encerrar Sessao API
*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-10-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}

CT-Pos-11-Carrinho-delete
    [Documentation]    Com um carrinho válido devidamente vinculado a um usuário tente concluir uma compra
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Concluir compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}

CT-Pos-12-Carrinho-delete
    [Documentation]    Com um carrinho válido devidamente vinculado a um usuário tente cancelar uma compra
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}

#---------------NEGATIVOS----------------#
Ct-Neg-13-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto duplicado
    [Tags]    Negativo
    Cadastrar carrinho com o produto repetido

Ct-Neg-14-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto e após isso tente criar mais um carrinho para o usuario
    [Tags]    Negativo
    Falhar em cadastrar carrinho: Não é permitido ter mais de 1 carrinho
    

Ct-Neg-15-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto que nao existe
    [Tags]    Negativo
    Falhar em cadastrar carrinho: Produto não existe

Ct-Neg-16-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto e no campo “quantidade” tente
    [Tags]    Negativo
    Falhar em cadastrar carrinho: Produto não possui quantidade suficiente
    Falhar em cadastrar carrinho: quantidade de produto é igual a 0
    Falhar em cadastrar carrinho: quantidade de produto é uma string
    
Ct-Neg-17-Carrinho-Post
    [Documentation]    Gere um token e tente criar um carrinho com este token
    [Tags]    Negativo
    Falhar em cadastrar carrinho: usuario nao existe

Ct-Neg-18-Carrinho-Post
    [Documentation]    logue com um usuario válido e espere o token expirar e tente criar um carrinho com este token
    [Tags]    Negativo
    Falhar em cadastrar carrinho: authorization expirado

Ct-Neg-19-Carrinho-Delete
    [Documentation]    gere um token e tente concluir uma compra
    [Tags]    Negativo
    falhar em concluir compra: authorization invalida

Ct-Neg-20-Carrinho-Delete
    [Documentation]    Tente concluir uma compra usando um usuário que não tem um carrinho
    [Tags]    Negativo
    Concluir compra com um usuario que nao tem carrinho

Ct-Neg-22-Carrinho-Delete
    [Documentation]    tente cancelar uma compra com um usuario que nao existe, para isso gere um token e tente cancelar uma compra
    [Tags]    Negativo
    Cancelar compra: usuario nao existe

Ct-Neg-23-Carrinho-Delete
    [Documentation]    Tente cancelar uma compra usando um usuário que não tem um carrinho
    [Tags]    Negativo
    Cancelar compra com um usuario que nao tem carrinho
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#