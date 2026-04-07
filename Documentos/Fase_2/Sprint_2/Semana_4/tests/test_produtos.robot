*** Settings ***
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
Suite Teardown   Run Keywords   Encerrar Sessao API  AND    Deletar Cliente e administrador

*** Test Cases ***

Pos-Carr-01
    [Tags]    Positivo
    Cadastrar produto dinamico valido    ${Adm_authorization}
    Sucesso em editar produto dinamicamente    ${ID_Produto}    ${Adm_authorization}