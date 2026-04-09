*** Settings ***
Resource  ../resources/Support/Bases/Configuracao.resource
Resource  ../resources/Support/fixtures/dynamics.robot
Suite Setup       Run Keywords    Iniciar Sessao API    AND    Criar Massa de Dados da Suite
Suite Teardown    Run Keywords    Limpar Massa de dados    AND    Encerrar Sessao API
Library    Collections

*** Variables ***
${preco_unitario}
${quantidade}

*** Test Cases ***



Cenario Positivo 01: Manipulacao de produtos
    [Tags]     Positivo  produtos  contrato
    [Documentation]    este teste tem como objetivo averiguar a api Nos seguintes aspectos:
    ...                   atende o contrato
    ...                   Como ela lida com cenario positivos
    Editar produto    A7f9K2mX8Qp4Zr1T    ${Adm_authorization}    Status_Code=201    nome=Produto Criado apartir do put
    Buscar produto por id    ${ID_Produto}
    Editar produto    ${ID_Produto}    ${Adm_authorization}    nome=Poltrona   preco=800    descricao=Poltrona Vintage    quantidade=200
    ${resposta}=   Buscar produto por id    ${ID_Produto}
    Should Be Equal As Strings    ${resposta}[nome]          Poltrona
    Should Be Equal As Numbers    ${resposta}[preco]        800
    Should Be Equal As Strings    ${resposta}[descricao]    Poltrona Vintage
    Should Be Equal As Numbers    ${resposta}[quantidade]    200

    Excluir produto    ${ID_Produto}    ${Adm_authorization}
    Buscar produto por id    ${ID_Produto}    Status_Code=400
    ${ID_Produto}=   Cadastrar produto    ${Adm_authorization}    ALEATORIO=${True}    
    Listar produtos
    Set Suite Variable    ${ID_Produto}

Cenario Positivo 02: Manipulacao de carrinhos
    [Documentation]    este teste tem como objetivo averiguar a api Nos seguintes aspectos:
    ...                   atende o contrato
    ...                   Como ela lida com cenario positivos
    [Tags]    Positivo carrinhos Contrato 
    ${ID_Carrinho}    ${quantidade}=    Cadastrar carrinho    ${Cliente_authorization}    ${ID_Produto}    Quantidade_Aleatoria=${True}
    ${resposta}=    Buscar carrinho por ID    ${ID_Carrinho}
    ${ProdutoDados}=    Buscar produto por id    ${ID_Produto}
    ${preco_unitario}=    Set Variable    ${ProdutoDados}[preco]

    Should Be Equal As Strings    ${resposta}[idUsuario]    ${ID_Cliente}
    #Valida os dados do produto (acessando o índice [0] da lista 'produtos')
    Should Be Equal As Strings    ${resposta}[produtos][0][idProduto]        ${ID_Produto}
    Should Be Equal As Strings    ${resposta}[produtos][0][quantidade]       ${quantidade}
    Should Be Equal As Strings    ${resposta}[produtos][0][precoUnitario]    ${preco_unitario}
    
    Cancelar compra    ${Cliente_authorization}
    Cadastrar carrinho    ${Cliente_authorization}    ${ID_Produto}    100
    Concluir compra    ${Cliente_authorization}

Cenario Negativo 01: Manipulacao de produtos
    [Documentation]    este teste tem como objetivo averiguar a api Nos seguintes aspectos:
    ...                   atende o contrato
    ...                   Consegue lidar com cenarios negativos
    [Tags]    Contrato Negativo produtos
    ${resposta}=    Buscar produto por id    ${ID_Produto}
    ${nome}=    Set Variable    ${resposta}
    Cadastrar produto    ${Adm_authorization}    nome=${nome}    Status_Code=400
    Cadastrar produto    123333    Status_Code=401
    Cadastrar produto    ${Cliente_authorization}    Status_Code=403

    Editar produto    ${ID_Produto}  ${Adm_authorization}    nome=${nome}    Status_Code=400
    Editar produto    ${ID_Produto}    11111   Status_Code=401
    Editar produto    ${ID_Produto}    ${Cliente_authorization}    Status_Code=403
    Editar produto    2222    ${Adm_authorization}    Status_Code=400
    Editar produto    ${EMPTY}   ${Adm_authorization}    Status_Code=405
    Listar produtos
    Excluir produto    A7F3K9X2M4Q8Z1B6    ${Adm_authorization}    Status_Code=404
    Cadastrar carrinho    ${Cliente_authorization}    ${ID_Produto}
    Excluir produto    ${ID_Produto}    ${Adm_authorization}    Status_Code=400
    Cancelar compra    ${Cliente_authorization}    
    Excluir produto    ${ID_Produto}    65441    Status_Code=401
    Excluir produto    ${ID_Produto}    ${Cliente_authorization}    403

Cenario Negativo 02: Manipulacao de carrinhos
    [Documentation]    este teste tem como objetivo averiguar a api Nos seguintes aspectos:
    ...                   atende o contrato
    ...                   Consegue lidar com cenarios negativos
    [Tags]    Contrato Negativo carrinhos
    ${resposta}=  Cadastrar carrinho    ${Cliente_authorization}    11111   Status_Code=400
    ${resposta}=  Cadastrar carrinho    2222222    ${ID_Produto}     Status_Code=401
    ${resposta}=  Cadastrar carrinho    111111    3333   Status_Code=401
    ${resposta}=  Cadastrar carrinho    ${Cliente_authorization}    id_Produto1=    quantidade=    Status_Code=400
    ${ID_Carrinho}=    Cadastrar carrinho    ${Cliente_authorization}    ${ID_Produto}    
    Cancelar compra    244    Status_Code=401
    Concluir compra    11    Status_Code=401
        
Cenario negativo 03: Logar usuario que nao existe
    [Tags]    negativo
    ${id}    ${email}    ${senha}=   Cadastrar Usuario   ALEATORIO=${True}    
    Logar no sistema    email=${email}    password=/*-12"!z:?''''""""    Status_Code=401
        Logar no sistema    email=${email}    password="    Status_Code=401


        