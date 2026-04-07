*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource

Suite Setup     Iniciar Sessao API
Suite Teardown   Encerrar Sessao API

*** Test Cases ***

Pos-Carr-01
    [Tags]    e2e    Positivo
    ${id}    ${email}    ${senha}=    Cadastrar Usario dinamico valido
    ${authorization}=    Logar no sistema Com sucesso    ${email}    ${senha}
    Cadastrar produto dinamico valido    ${authorization}
    #descobrir um jeito de ver quanto de produto foi criado
    Cadastrar carrinho com sucesso    ${authorization}    ${id_produto}
    Concluir compra com carrinho associado ao usuario com sucesso    ${authorization}
    #descobrir um jeito de ver quanto sobrou de produtos
    Buscar item por ID no endpoint "${ROTA_CARRINHOS}"    ${ID_Carrinho}    400
    Excluir produto com sucesso: Produto existente    ${ID_Produto}    ${authorization}
    Excluir Usuario sem carrinho com suscesso    ${id}
Reg-Carr-01
    [Documentation]
    [Tags]    regra de negocio
    ${id}    ${email}    ${senha}=    Cadastrar Usario dinamico valido
    ${authorization}=    Logar no sistema Com sucesso    ${email}    ${senha}
    Cadastrar produto dinamico valido    ${authorization}
    #descobrir um jeito de ver quanto de produto foi criado
    Cadastrar carrinho com sucesso    ${authorization}    ${id_produto}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${authorization}
    #descobrir um jeito de ver quanto sobrou de produtos
    Buscar item por ID no endpoint "${ROTA_CARRINHOS}"    ${ID_Carrinho}    400
    Excluir produto com sucesso: Produto existente    ${ID_Produto}    ${authorization}
    Excluir Usuario sem carrinho com suscesso    ${id}