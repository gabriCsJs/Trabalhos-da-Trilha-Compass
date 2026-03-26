*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource


*** Variables ***

${ROTA_PRODUTOS}     /produtos

*** Keywords ***

#-------------Validado-------------#

Cadastrar produto estatico valido
    [Arguments]    ${Authorization}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/produtos.json
    ${body}    Set Variable    ${json["produtos_Validos"]}
    ${id}=    Cadastrar produto    ${Authorization}    ${body}
    RETURN    ${id}


Cadastrar produto dinamico valido
    [Arguments]    ${Authorization}
    ${payload}    Criar dados para produtos validos
    Log   ${payload}
    ${id}=    Cadastrar produto    ${Authorization}    ${payload}
    RETURN    ${id}

Cadastrar produto
    [Arguments]    ${Authorization}    ${body}
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_PRODUTOS}    json=&{body}    headers=${Header}
    log    ${response}
    RETURN    ${response.json()}[_id]

Editar produto
    [Arguments]    ${id}    ${Authorization}    ${body}
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    PUT On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id}    json=&{body}    headers=${Header}
    log    ${response}

Excluir produto
    [Arguments]    ${id}    ${Authorization}
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    DELETE On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id}    headers=${Header}
    log    ${response}

