*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
Suite Teardown   Run Keywords   Encerrar Sessao API  AND    Deletar Cliente e administrador


*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-01-Login-Post
    [Documentation]     Validar autenticação com credenciais válidas e geração de token de acesso conforme contrato.
    [Tags]    Positivo
    Logar no sistema Com sucesso    ${Email_Cliente}    ${Password_Cliente}


#---------------NEGATIVOS----------------#
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#