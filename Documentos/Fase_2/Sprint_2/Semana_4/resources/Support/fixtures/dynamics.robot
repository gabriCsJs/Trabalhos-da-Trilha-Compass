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

Gerar id alfanumerico
    [Arguments]    ${tamanho}=16
    ${id_dinamico}=    Generate Random String    ${tamanho}    [LETTERS][NUMBERS]
    RETURN    ${id_dinamico}
