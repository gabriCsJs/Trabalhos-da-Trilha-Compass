*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource


Suite Setup     Iniciar Sessao API
Suite Teardown   Encerrar Sessao API

*** Test Cases ***


Teste Completo
    [Documentation]    Happy Path: Cadastro → Login → Produto → Carrinho → Concluir Compra
    [Tags]    Positivo    e2e
    ${id}    ${email}    ${senha}=    Cadastrar Usario dinamico valido
    ${authorization}=    Logar no sistema Com sucesso    ${email}    ${senha}
    Cadastrar produto dinamico valido    ${authorization}
    Cadastrar carrinho com sucesso    ${authorization}    ${ID_Produto}
    Concluir compra com carrinho associado ao usuario com sucesso    ${authorization}
    Excluir produto com sucesso: Produto existente    ${ID_Produto}    ${authorization}
    Excluir Usuario sem carrinho com suscesso    ${id}