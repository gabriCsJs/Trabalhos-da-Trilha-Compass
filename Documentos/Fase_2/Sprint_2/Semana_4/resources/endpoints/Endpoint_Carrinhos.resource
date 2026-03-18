*** Settings ***
Library  RequestsLibrary
Library  String

*** Variables ***
${ROTA_CARRINHOS}                 /carrinhos
${ROTA_CONCLUIR_COMPRA}           /carrinhos/concluir-compra
${ROTA_CANCELAR_COMPRA}           /carrinhos/cancelar-compra

*** Keywords ***

#-------------GET-------------#
Listar carrinhos cadastrados
    
    ${response}=  Get On Session    alias=Serverest   url=${ROTA_CARRINHOS}    expected_status=200

Buscar carrinho por ID
    [Arguments]      ${id}    ${Status_Code}=200
    ${response}=  Get On Session    alias=Serverest    url=${ROTA_CARRINHOS}/${id}    expected_status=${Status_Code}
    RETURN    ${response.json()}

#-------------POST-------------#
Cadastrar carrinho
    [Arguments]    ${authorization}  ${id_Produto1}    ${quantidade}=100    ${Status_Code}=201   ${Quantidade_Aleatoria}=${False} 
    &{Header}  Create Dictionary  Authorization=${authorization}
    IF    ${Quantidade_Aleatoria}==${True}
        ${quantidade}    Generate Random String    length=3    chars=[NUMBERS]
    END
    &{produto_item}    Create Dictionary    idProduto=${id_Produto1}    quantidade=${quantidade}
    @{lista_produtos}    Create List    ${produto_item}
    &{Body}    Create Dictionary    produtos=${lista_produtos}

    ${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}
    IF    "${Status_Code}" == "201"
        RETURN   ${response.json()}[_id]    ${quantidade}
    # ELSE
    #     RETURN   ${response.json()}
    END

#-------------DELETE-------------#
Concluir compra
    [Arguments]    ${authorization}    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CONCLUIR_COMPRA}   headers=${Header}   expected_status=${Status_Code}

Cancelar compra
    [Arguments]    ${authorization}    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CANCELAR_COMPRA}   headers=${Header}   expected_status=${Status_Code}
    