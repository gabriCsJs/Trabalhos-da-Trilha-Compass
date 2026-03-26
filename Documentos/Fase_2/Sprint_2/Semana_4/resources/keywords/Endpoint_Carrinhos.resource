*** Settings ***
Library    RequestsLibrary
Library    String
Resource    ../Support/fixtures/dynamics.robot
Resource    ../Support/Bases/Configuracao.resource

*** Variables ***
${ROTA_CARRINHOS}                 /carrinhos
${ROTA_CONCLUIR_COMPRA}           /carrinhos/concluir-compra
${ROTA_CANCELAR_COMPRA}           /carrinhos/cancelar-compra

*** Keywords ***

#-------------POST-------------#
# Cadastrar carrinho dinamico valido
#     ${body}    Criar dados para carrinhos validos
#     Cadastrar carrinho    ${Cliente_authorization}    ${body}

Cadastrar carrinho
    [Arguments]    ${authorization}  ${id_Produto}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${numero}    Evaluate    random.randint(2, 3)    random
    ${quantidade}    Generate Random String    length=${numero}    chars=[NUMBERS]
    &{produto_item}    Create Dictionary    idProduto=${id_Produto}    quantidade=${quantidade}
    @{lista_produtos}    Create List    ${produto_item}
    &{Body}    Create Dictionary    produtos=${lista_produtos}
    ${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}
    RETURN   ${response.json()}[_id]


# Cadastrar carrinho
    # [Arguments]    ${authorization}  ${body}
    # &{Header}  Create Dictionary  Authorization=${authorization}
    # ${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}
    #     RETURN   ${response.json()}[_id]

#-------------DELETE-------------#
Concluir compra
    [Arguments]    ${authorization}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CONCLUIR_COMPRA}   headers=${Header}

Cancelar compra
    [Arguments]    ${authorization}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CANCELAR_COMPRA}   headers=${Header}
    
