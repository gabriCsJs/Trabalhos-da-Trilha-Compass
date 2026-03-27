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

Cadastrar carrinho
    [Arguments]    ${authorization}  ${id_Produto}    ${statuscode}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${numero}    Evaluate    random.randint(2, 3)    random
    ${quantidade}    Generate Random String    length=${numero}    chars=[NUMBERS]
    &{produto_item}    Create Dictionary    idProduto=${id_Produto}    quantidade=${quantidade}
    @{lista_produtos}    Create List    ${produto_item}
    &{Body}    Create Dictionary    produtos=${lista_produtos}
    ${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}
    IF    ${statuscode}==201
        RETURN   ${response.json()}[_id]   ${response.json()}[message]
    ELSE
        RETURN   ${response.json()}[message]
    END
    


Concluir compra: sucesso
    [Arguments]    ${authorization}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CONCLUIR_COMPRA}   headers=${Header}
Concluir compra: usuario nao existe

Cancelar compra
    [Arguments]    ${authorization}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${ROTA_CANCELAR_COMPRA}   headers=${Header}
    
Concelar compra: usuario nao existe

Falhar em cadastrar carrinho: Não é permitido ter mais de 1 carrinho 400
Falhar em cadastrar carrinho: Produto não encontrado 400
Falhar em cadastrar carrinho: Produto não possui quantidade suficiente 400
Falhar em cadastrar carrinho: Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

falhar em concluir compra: authorization invalida
falhar em cancelar compra: authorization invalida
