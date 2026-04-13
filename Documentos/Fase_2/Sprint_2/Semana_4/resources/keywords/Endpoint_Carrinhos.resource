*** Settings ***
Library    RequestsLibrary
Library    String
Resource    ../Support/fixtures/dynamics.robot
Resource    ../Support/Bases/Configuracao.resource

*** Variables ***
${ROTA_CARRINHOS}                 /carrinhos
${ROTA_CONCLUIR_COMPRA}           /carrinhos/concluir-compra
${ROTA_CANCELAR_COMPRA}           /carrinhos/cancelar-compra
${MSG_REGISTRO_EXCLUIDO}          Registro excluído com sucesso
${MSG_CARRINHO_NAO_ENCONTRADO}    Não foi encontrado carrinho para esse usuário
${MSG_TOKEN_INVALIDO}             Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
${MSG_MAIS_DE_UM_CARRINHO}        Não é permitido ter mais de 1 carrinho
${MSG_PRODUTO_NAO_ENCONTRADO}     Produto não encontrado
${MSG_QUANTIDADE_INSUFICIENTE}    Produto não possui quantidade suficiente

*** Keywords ***

#-------------Só pensei nessas keywords, agora devemos validar se elas estao funcionando-------------#
Post carrinho
    [Arguments]    ${authorization}    ${statuscode}   @{ids_produtos}    ${retornar}=${True}  
    &{Header}    Create Dictionary    Authorization=${authorization}
    @{lista_produtos}    Create List
    FOR    ${id}    IN    @{ids_produtos}
        ${quantidade}=    gerar quantidade aleatoria
        &{item}=    Create Dictionary    idProduto=${id}    quantidade=${quantidade}
        Append To List    ${lista_produtos}    ${item}
    END
    &{Body}    Create Dictionary    produtos=${lista_produtos}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_CARRINHOS}    json=&{Body}    headers=${Header}    expected_status=${statuscode}
    IF    ${retornar}==${True}
        IF    ${statuscode}==201
            RETURN    ${response.json()}[_id]    ${response.json()}[message]
        ELSE
            RETURN    ${response.json()}[message]
        END
    END

Cadastrar carrinho com sucesso
    [Arguments]    ${authorization}    ${id_Produto}   ${Guardar_Var_na_Global}=${True}
    ${quantidade}=   gerar quantidade aleatoria
    ${id}  ${mensagem}=   Post carrinho    ${authorization}  201  ${id_Produto}         
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
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    200    ${MSG_REGISTRO_EXCLUIDO}    ${authorization}

Concluir compra com um usuario que nao tem carrinho
    [Arguments]    ${authorization}=${Cliente_authorization}
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    200    ${MSG_CARRINHO_NAO_ENCONTRADO}    ${authorization}

Concluir compra: usuario nao existe
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    401    ${MSG_TOKEN_INVALIDO}

Cancelar compra com carrinho associado ao usuario com sucesso
    [Arguments]    ${authorization}
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    200    ${MSG_REGISTRO_EXCLUIDO}    ${authorization}

Cancelar compra com um usuario que nao tem carrinho
    [Arguments]    ${authorization}=${Cliente_authorization}
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    200    ${MSG_CARRINHO_NAO_ENCONTRADO}    ${authorization}

Cancelar compra: usuario nao existe
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    401    ${MSG_TOKEN_INVALIDO}

Falhar em cadastrar carrinho: Não é permitido ter mais de 1 carrinho
    [Arguments]    ${authorization}=${Cliente_authorization}    ${id_Produto}=${ID_Produto}
    Post carrinho    ${authorization}  201  ${id_Produto}    retornar=${False}
    ${mensagem}=    Post carrinho    ${authorization}  400  ${id_Produto}  
    Should Be Equal    ${mensagem}    ${MSG_MAIS_DE_UM_CARRINHO}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${authorization}

Falhar em cadastrar carrinho: Produto não existe
    [Arguments]    ${authorization}=${Adm_authorization}
    ${id}=   Gerar id alfanumerico
    ${mensagem}=  Post carrinho    ${authorization}  400  ${id} 
    Should Be Equal    ${mensagem}    ${MSG_PRODUTO_NAO_ENCONTRADO}

# Falhar em cadastrar carrinho com quantidade inválida
#     [Arguments]    ${quantidade}    ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
#     &{header}=    Create Dictionary    Authorization=${authorization}
#     &{produto_item}=    Create Dictionary    idProduto=${id_Produto}    quantidade=${quantidade}
#     @{lista_produtos}=    Create List    ${produto_item}
#     &{body}=    Create Dictionary    produtos=${lista_produtos}
#     ${response}=    POST On Session    alias=Serverest    url=${ROTA_CARRINHOS}    json=&{body}    headers=${header}    expected_status=400
#     Should Be Equal    ${response.json()}[message]    ${MSG_QUANTIDADE_INSUFICIENTE}

Falhar em cadastrar carrinho com quantidade inválida
    [Arguments]    ${quantidade}    ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
    &{header}=    Create Dictionary    Authorization=${authorization}
    &{produto_item}=    Create Dictionary    idProduto=${id_Produto}    quantidade=${quantidade}
    @{lista_produtos}=    Create List    ${produto_item}
    &{body}=    Create Dictionary    produtos=${lista_produtos}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_CARRINHOS}    json=&{body}    headers=${header}    expected_status=400
    ${json}=    Set Variable    ${response.json()}
    IF    'message' in $json
        Should Be Equal    ${json}[message]    ${MSG_QUANTIDADE_INSUFICIENTE}
    ELSE
        RETURN    ${json}[produtos]
    END


Falhar em cadastrar carrinho: Produto não possui quantidade suficiente
    [Arguments]   ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
    Falhar em cadastrar carrinho com quantidade inválida    -58

Falhar em cadastrar carrinho: quantidade de produto é igual a 0
    [Arguments]   ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
    Falhar em cadastrar carrinho com quantidade inválida    0

Falhar em cadastrar carrinho: quantidade de produto é uma string
    [Arguments]   ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
    Falhar em cadastrar carrinho com quantidade inválida    isso e uma string com letras

Falhar em cadastrar carrinho: usuario nao existe
    [Arguments]    ${id_Produto}=${ID_Produto}
    ${authorization_Falsa}=  Gerar Bearer Token Falso
    ${mensagem}=    Post carrinho    ${authorization_Falsa}  401  ${id_Produto}
    Should Be Equal    ${mensagem}    ${MSG_TOKEN_INVALIDO}

Falhar em cadastrar carrinho: authorization expirado
    [Arguments]    ${authorization}=${Adm_authorization}    ${id_Produto}=${ID_Produto}
    Esperar Token invalidar
    ${mensagem}=   Post carrinho    ${authorization}    401    ${id_Produto}
    Should Be Equal    ${mensagem}    ${MSG_TOKEN_INVALIDO}

falhar em concluir compra: authorization invalida
    _Validar acao de compra    ${ROTA_CONCLUIR_COMPRA}    401    ${MSG_TOKEN_INVALIDO}

falhar em cancelar compra: authorization invalida
    _Validar acao de compra    ${ROTA_CANCELAR_COMPRA}    401    ${MSG_TOKEN_INVALIDO}

Cadastrar carrinho com o produto repetido   
    [Arguments]     ${id_produto}=${ID_Produto}    ${authorization}=${Adm_authorization}
    ${mensagem}=    Post carrinho    ${authorization}    400    ${id_produto}    ${id_produto}
    Should Be Equal    ${mensagem}    Não é permitido possuir produto duplicado