*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
Suite Teardown   Run Keywords   Encerrar Sessao API  AND    Deletar Cliente e administrador


*** Test Cases ***

Pos-Login-01 - Validar autenticação do usuário valido
    Logar no sistema Com sucesso    ${Email_Cliente}    ${Password_Cliente}
    
