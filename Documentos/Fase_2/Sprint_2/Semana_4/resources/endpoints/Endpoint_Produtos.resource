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
    # RETURN    ${response.json()}

Buscar produto por id
    [Arguments]    ${id}    ${Status_Code}=200
    ${response}=  Get On Session  alias=Serverest  url=${ROTA_PRODUTOS}/${id}    expected_status=${Status_Code}
    RETURN    ${response.json()}
#-------------POST-------------#

Cadastrar produto
    [Arguments]    ${Authorization}    ${nome}=Teclado1 RedDragon    ${preco}=350    
    ...            ${descricao}=teclado    ${quantidade}=1000    ${Status_Code}=201    ${ALEATORIO}=${false}    ${Tamanho}=10
    &{Header}    Create Dictionary    Authorization=${Authorization}
    IF    ${ALEATORIO} == ${true}
        ${nome}    Generate Random String    length=${Tamanho}    chars=[LETTERS]
        ${preco}    Generate Random String    length=3    chars=[NUMBERS]
        ${descricao}    Set Variable    Esse produto foi gerado aleatoriamente
    END
    &{Body}    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${response}    POST On Session    alias=Serverest    url=${ROTA_PRODUTOS}    json=${Body}    headers=${Header}    expected_status=${Status_Code}
    IF    ${Status_Code}==201
        RETURN    ${response.json()}[_id]
    END
    
    
#-------------PUT-------------#

Editar produto
    [Arguments]  ${id_Produto}  ${Authorization}  ${nome}=Mouse1 RedDragon    ${preco}=100    ${descricao}=Mause    ${quantidade}=2000    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}

    &{Body}    Create Dictionary  nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    
    PUT On Session  alias=Serverest  url=${ROTA_PRODUTOS}/${id_Produto}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}

#-------------DELETE-------------#
Excluir produto
    [Arguments]  ${id}  ${Authorization}    ${Status_Code}=200
    &{Header}  Create Dictionary  Authorization=${authorization}
    ${response}=  DELETE On Session  alias=Serverest   url=${ROTA_PRODUTOS}/${id}   headers=${Header}   expected_status=${Status_Code}