*** Settings ***
Resource  ../resources/keywords.resource
Suite Setup       Criar Massa de Dados da Suite
Suite Teardown    Limpar Massa de dados

*** Test Cases ***

Cenário 01: Validar busca de usuário por ID
    [Tags]    positivo
    GET - Buscar Usuario por ID    ${ID_Cliente}
    GET - Buscar Usuario por ID    ${ID_Adm}
    PUT - Editar Usuario  ${ID_Cliente}
    GET - Buscar Usuario por ID    ${ID_Cliente}
    Limpar Massa de dados
