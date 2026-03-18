*** Settings ***
Resource  ../resources/Base/setup_teardown.resource
Suite Setup       Run Keywords    Iniciar Sessao API    AND    Criar Massa de Dados da Suite
Suite Teardown    Run Keywords    Limpar Massa de dados    AND    Encerrar Sessao API
Library    Collections

*** Variables ***
${preco_unitario}
${quantidade}

*** Test Cases ***

Validar estrutura do JSON de Produto
    [Documentation]    Verifica se a API retorna os campos obrigatórios na busca de um produto.
    [Tags]             contrato    produtos
    # Fazemos a busca do produto criado no Setup
    ${resposta}=    Buscar produto por id    ${ID_Produto}
    
    Dictionary Should Contain Key    ${resposta}    nome
    Dictionary Should Contain Key    ${resposta}    preco
    Dictionary Should Contain Key    ${resposta}    descricao
    Dictionary Should Contain Key    ${resposta}    quantidade
    Dictionary Should Contain Key    ${resposta}    _id

Validar estrutura do JSON de Usuario
    [Documentation]    Verifica se a API retorna os campos obrigatórios na busca de um Usuario.
    [Tags]             contrato    usuarios
    # Fazemos a busca do produto criado no Setup
    ${resposta}=    Buscar Usuario por ID    ${ID_Cliente}
    Dictionary Should Contain Key    ${resposta}    nome
    Dictionary Should Contain Key    ${resposta}    email
    Dictionary Should Contain Key    ${resposta}    password
    Dictionary Should Contain Key    ${resposta}    administrador
    Dictionary Should Contain Key    ${resposta}    _id


Cenario Positivo 01: Manipulacao de produtos
    [Tags]     Positivo  produtos  contrato
    [Documentation]    este teste tem como objetivo averiguar a api Nos seguintes aspectos:
    ...                   atende o contrato
    ...                   Como ela lida com cenario positivos
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
    # Editar produto    2222    ${ID_Adm}    a documentaçao nao fala oque acontece quando nao se encontra o ID

    # Excluir produto    22222    ${Adm_authorization}    Status_Code=?
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