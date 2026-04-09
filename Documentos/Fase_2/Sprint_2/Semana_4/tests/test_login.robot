*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource

Suite Setup    Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
Suite Teardown   Run Keywords  Deletar Cliente e administrador    AND      Encerrar Sessao API    


*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-01-Login-Post
    [Documentation]     Validar autenticação com credenciais válidas e geração de token de acesso conforme contrato.
    [Tags]    Positivo
    Logar no sistema Com sucesso    ${Email_Cliente}    ${Password_Cliente}
#---------------NEGATIVOS----------------#
CT-Neg-01-Login-Post
    [Documentation]     Tentar autenticar um usuário inexistente no sistema
    [Tags]    Negativo
    Falhar em logar: Email errado
CT-Neg-02-Login-Post
    [Documentation]     Tentar autenticar um usuário existente mas informar uma senha inválida
    [Tags]    Negativo
    Falhar em logar: Senha errada 
CT-Neg-03-Login-Post
    [Documentation]     Tentar autenticar um usuário existente mas informar uma senha inválida com o objetivo de testar se a API discrimina letras maiúsculas de minúsculas
    [Tags]    Negativo
    Falhar em logar: Senha Com letra maiusculas   
#---------------CONTRATO-----------------#
#---------------NEGOCIO------------------#