*** Settings ***
Library    FakerLibrary
Library    String
Resource    ../Variebles/serverest_variables.robot
Resource    ../common/common.robot

*** Keywords ***

Criar dados para usuarios validos
    ${nome}    FakerLibrary.Name
    ${email}=    Gerar email aleatorio valido
    ${senha}=    Gerar Senha aleatoria
    &{playload}    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=true
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

Gerar Senha aleatoria
    ${tamanho} =  FakerLibrary.Random Int    min=10    max=25
    ${senha}=    FakerLibrary.Password    length=${tamanho}    
    RETURN    ${senha}

Gerar email aleatorio valido
    ${email}=    FakerLibrary.Email
    RETURN    ${email}

Gerar email aleatorio invalido
    ${email}=    FakerLibrary.Email    safe=False
    RETURN    ${email}

Gerar Bearer Token Falso
    ${token}=    Generate Random String    48    [LETTERS][NUMBERS]
    RETURN    Bearer ${token}

gerar quantidade aleatoria
    ${numero}    Evaluate    random.randint(2, 3)    random
    ${quantidade}    Generate Random String    length=${numero}    chars=[NUMBERS]
    RETURN    ${quantidade}

