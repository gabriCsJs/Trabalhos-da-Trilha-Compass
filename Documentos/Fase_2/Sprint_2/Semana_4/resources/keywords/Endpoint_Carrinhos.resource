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

#-------------Só pensei nessas keywords, agora devemos validar se elas estao funcionando-------------#


Post carrinho
    [Arguments]    ${authorization}  ${id_Produto}    ${statuscode}  ${quantidade}  ${retornar}=${True}  
    &{Header}  Create Dictionary  Authorization=${authorization}
    &{produto_item}    Create Dictionary    idProduto=${id_Produto}    quantidade=${quantidade}
    @{lista_produtos}    Create List    ${produto_item}
    &{Body}    Create Dictionary    produtos=${lista_produtos}
    ${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}   expected_status=${statuscode}
    IF    ${retornar}==${True}
        IF    ${statuscode}==201
            RETURN   ${response.json()}[_id]   ${response.json()}[message]
        ELSE
            RETURN   ${response.json()}[message]
        END
    END

Cadastrar carrinho com sucesso
    [Arguments]    ${authorization}    ${id_Produto}   ${Guardar_Var_na_Global}=${True}
    ${quantidade}=   gerar quantidade aleatoria
    ${id}  ${mensagem}=   Post carrinho    ${authorization}    ${id_Produto}    201    ${quantidade}  
    Should Be Equal    ${mensagem}    Cadastro realizado com sucesso
    IF     ${Guardar_Var_na_Global}==${True}
        Set Global Variable    ${ID_Carrinho}    ${id}
    ELSE
        RETURN    ${id}
    END

Delete carrinho
    [Arguments]    ${authorization}    ${stuatuscode}    ${rota}
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session    alias=Serverest     url=${rota}   headers=${Header}    expected_status=${stuatuscode}
    RETURN    ${response.json()}[message]

_Validar acao de compra
    [Arguments]    ${rota}    ${statuscode}    ${mensagem_esperada}    ${authorization}=${NONE}
    IF    $authorization is None
        ${authorization}=    Gerar Bearer Token Falso
    END
    ${mensagem}=    Delete carrinho    ${authorization}    ${statuscode}    ${rota}
    Should Be Equal    ${mensagem}    ${mensagem_esperada}

Concluir compra com carrinho associado ao usuario com sucesso
    [Arguments]    ${authorization}
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    200    Registro excluído com sucesso    ${authorization}

Concluir compra com um usuario que nao tem carrinho
    [Arguments]    ${authorization}
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    200    Não foi encontrado carrinho para esse usuário    ${authorization}

Concluir compra: usuario nao existe
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    401    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Cancelar compra com carrinho associado ao usuario com sucesso
    [Arguments]    ${authorization}
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    200    Registro excluído com sucesso    ${authorization}

Cancelar compra com um usuario que nao tem carrinho
    [Arguments]    ${authorization}
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    200    Não foi encontrado carrinho para esse usuário    ${authorization}

Cancelar compra: usuario nao existe
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    401    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Falhar em cadastrar carrinho: Não é permitido ter mais de 1 carrinho 400
    [Arguments]    ${authorization}    ${id_Produto}
    ${quantidade}=   gerar quantidade aleatoria
    Post carrinho    ${authorization}    ${id_Produto}    201   ${quantidade}   retornar=${False}
    ${mensagem}=    Post carrinho    ${authorization}    ${id_Produto}    400    ${quantidade}
    Should Be Equal    ${mensagem}    Não é permitido ter mais de 1 carrinho
    
Falhar em cadastrar carrinho: Produto não encontrado 400
    [Arguments]    ${authorization}
    ${id}=   Gerar id alfanumerico
    ${quantidade}=   gerar quantidade aleatoria
    ${mensagem}=  Post carrinho    ${authorization}    ${id}    400    ${quantidade}
    Should Be Empty    ${mensagem}    Produto não encontrado

#---------revisar isso aqui porque foi o amazonQ que fez-------------#
Falhar em cadastrar carrinho: Produto não possui quantidade suficiente 400
    [Arguments]    ${authorization}    ${id_Produto}
    ${mensagem}=    Post carrinho    ${authorization}    ${id_Produto}    400    9999
    Should Be Equal    ${mensagem}    Produto não possui quantidade suficiente

Falhar em cadastrar carrinho: Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    [Arguments]    ${id_Produto}
    ${quantidade}=    gerar quantidade aleatoria
    ${mensagem}=    Post carrinho    ${NONE}    ${id_Produto}    401    ${quantidade}
    Should Be Equal    ${mensagem}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

falhar em concluir compra: authorization invalida
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    401    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

falhar em cancelar compra: authorization invalida
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    401    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
