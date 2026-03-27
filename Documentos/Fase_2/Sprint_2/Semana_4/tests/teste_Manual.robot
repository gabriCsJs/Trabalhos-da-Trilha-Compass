*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource
Resource  ../resources/keywords/Endpoint_Login.resource

Suite Setup     Iniciar Sessao API
Suite Teardown   Encerrar Sessao API

*** Test Cases ***


Teste manual cadastrar usuario
    ${ID_Cliente}    ${Email_Cliente}    ${Password_Cliente}=    Cadastrar usario dinamico valido
    Editar usuario Dinamicamente    ${ID_Cliente}
    Excluir Usuario    ${ID_Cliente}
    Listar itens cadastrados no endpoint "${ROTA_USUARIOS}"
Teste manual cadastrar usuario estatico
    Cadastrar Usuario estatico valido
    Listar itens cadastrados no endpoint "${ROTA_USUARIOS}"
Teste completo
    Cadastrar Cliente e administrador
    Cadastrar produto dinamico valido    ${Adm_authorization}
    Cadastrar carrinho    ${Cliente_authorization}    ${ID_Produto}
    Concluir compra    ${Cliente_authorization}
    Excluir produto    ${ID_Produto}    ${Adm_authorization}
    Excluir Usuario    ${ID_Adm}
    Excluir Usuario    ${ID_Cliente}