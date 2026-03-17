*** Settings ***
Library  RequestsLibrary
Library  String

*** Variables ***

${ROTA_PRODUTOS}     /produtos

*** Keywords ***

#-------------GET-------------#

Listar produtos
    [Arguments]    ${Status_Code}=200
    ${response}=  Get On Session    alias=Serverest  url=${ROTA_PRODUTOS}    expected_status=${Status_Code}

Buscar produto por id
    [Arguments]    ${id}    ${Status_Code}=200
    ${response}=  Get On Session  alias=Serverest  url=${ROTA_PRODUTOS}/${id}    expected_status=${Status_Code}
#-------------POST-------------#
Cadastrar produto
    [Arguments]   ${Authorization}  ${nome}=Teclado1 RedDragon    ${preco}=350    ${descricao}=teclado    ${quantidade}=10    ${Status_Code}=201
    &{Header}  Create Dictionary  Authorization=${authorization}
    &{Body}    Create Dictionary  nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}

    ${response}=  POST On Session    alias=Serverest   url=${ROTA_PRODUTOS}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}
    RETURN    ${response.json()}[_id]
#-------------PUT-------------#

Editar produto
    [Arguments]  ${id}  ${Authorization}  ${nome}=Mouse1 RedDragon    ${preco}=100    ${descricao}=Mause    ${quantidade}=100    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}

    &{Body}    Create Dictionary  nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    
    ${response}=  PUT On Session  alias=Serverest  url=${ROTA_PRODUTOS}/${id}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}

#-------------DELETE-------------#
Deletar produto
    [Arguments]  ${id}  ${Authorization}    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session  alias=Serverest   url=${ROTA_PRODUTOS}/${id}   headers=${Header}   expected_status=${Status_Code}