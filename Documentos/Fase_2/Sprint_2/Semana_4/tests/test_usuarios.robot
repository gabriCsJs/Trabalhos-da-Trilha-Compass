*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup     Iniciar Sessao API
Suite Teardown   Encerrar Sessao API

*** Test Cases ***


Reg-Usu-01
    [Tags]    Regra de negocio
    Criar usario Dinamicamente pelo PUT com sucesso
Reg-Usu-02
    [Tags]    Regra de negocio
    ${id}    ${email}    ${senha}=    Cadastrar Usario dinamico valido
    Excluir Usuario sem carrinho com suscesso    ${id}


