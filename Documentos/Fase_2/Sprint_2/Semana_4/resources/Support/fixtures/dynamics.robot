*** Settings ***
Library    FakerLibrary
Library    String
Resource    ../Variebles/serverest_variables.robot
Resource    ../common/common.robot

*** Keywords ***

Criar dados para usuarios validos
    ${nome}    FakerLibrary.Name
    ${email}    FakerLibrary.Email
    &{playload}    Create Dictionary    nome=${nome}    email=${email}    password=password    administrador=true
    Log     eu estou no dynamics: ${playload}
    RETURN    &{playload}

Criar dados para produtos validos
    ${string_aleatoria}    Generate Random String    6    [LETTERS][NUMBERS]
    ${nome}    Set Variable    Produto ${string_aleatoria}
    ${preco}    FakerLibrary.Random Int    min=10    max=5000
    ${descricao}    FakerLibrary.Sentence
    ${quantidade}    FakerLibrary.Random Int    min=1000    max=1500
    ${payload}    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    Log To Console    ${payload}
    RETURN    ${payload}

# Criar dados para carrinhos validos
#     ${resposta}=        Listar itens cadastrados no endpoint "/produtos"
#     Log To Console    ${resposta}
#     Log  ${resposta}
#     ${lista_produtos}=    Get From Dictionary    ${resposta}    produtos
#     ${indice_aleatorio}=    FakerLibrary.Random Int    min=0    max=${resposta}[quantidade] - 1
#     ${produto_escolhido}=    Get From List    ${lista_produtos}    ${indice_aleatorio}
#     ${quantidade}=    FakerLibrary.Random Int    min=1    max=${produto_escolhido}[quantidade]
#     &{produto_item}=    Create Dictionary    idProduto=${produto_escolhido}[_id]    quantidade=${quantidade}
#     @{produtos}=    Create List    ${produto_item}
#     &{payload}=    Create Dictionary    produtos=${produtos}
#     Log To Console    ${payload}
#     RETURN    ${payload}


