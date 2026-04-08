*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource

Test Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador  AND  Cadastrar produto dinamico valido
Test Teardown   Run Keywords   Encerrar Sessao API    AND   Excluir produto com sucesso: Produto existente   AND    Deletar Cliente e administrador

*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-10-Carrinho-Post
    [Documentation]    Crie um carrinho vinculado a um usuário válido contendo um produto
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}

CT-Pos-11-Carrinho-delete
    [Documentation]    Com um carrinho válido devidamente vinculado a um usuário tente concluir uma compra
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Concluir compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}

CT-Pos-12-Carrinho-delete
    [Documentation]
    [Tags]    Positivo
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}


#---------------NEGATIVOS----------------#
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#