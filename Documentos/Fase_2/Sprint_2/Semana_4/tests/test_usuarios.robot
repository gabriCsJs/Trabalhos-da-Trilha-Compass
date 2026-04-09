*** Settings ***
Resource  ../resources/keywords/Endpoint_Usuario.resource
Resource  ../resources/keywords/Endpoint_Produtos.resource
Resource  ../resources/keywords/Endpoint_Carrinhos.resource

Test Setup   Run Keywords    Iniciar Sessao API    AND    Cadastrar Cliente e administrador
test Teardown   Run Keywords  Deletar Cliente e administrador    AND      Encerrar Sessao API    


*** Test Cases ***

#---------------POSITIVOS----------------#
CT-Pos-02-User-Delete
    [Documentation]    deleta um usuário sem carrinho ativo com sucesso
    [Tags]    Positivo
    Excluir um usuario sem carrinho com sucesso
CT-Pos-03-User-Delete
    [Documentation]    Gerar ID e enviar uma requisiçao para a api deletar o usuario
    [Tags]    Positivo
    Excluir usuario que nao existe
CT-Pos-04-User-Put
    [Documentation]    Gerar ID e enviar uma requisiçao para a api deletar o usuario
    [Tags]    Positivo
    Criar e Editar um usuario com sucesso
CT-Pos-14-User-Post
    [Documentation]    Criar usuario com sucesso
    [Tags]    Positivo
    ${id}  ${email}  ${senha}=  Cadastrar Usuario dinamico valido
    Excluir Usuario com sucesso    ${id}
#---------------NEGATIVOS----------------#
CT-Neg-04-User-delete
    [Documentation]    validar se a api impede a exclusão de um usuário com carrinho
    [Tags]    Negativo
    Cadastrar produto dinamico valido
    Cadastrar carrinho com sucesso    ${Cliente_authorization}    ${ID_Produto}
    Falhar em excluir usuario com carrinho cadastrado    ${ID_Cliente}
    Cancelar compra com carrinho associado ao usuario com sucesso    ${Cliente_authorization}
    Excluir produto com sucesso: Produto existente

CT-Neg-05-User-delete
    [Documentation]    Validar regra de unicidade de e-mail ao tentar cadastrar usuário com e-mail já existente
    [Tags]    Negativo
    Falhar em cadastrar usario com email ja cadastrado Pelo POST
Ct-Neg-06-User-Put
    [Documentation]    Tentar cadastrar um usuário pelo put com um email ja cadastrado para validar se a api garante a unicidade de emails
    [Tags]    Negativo
    falhar em cadastrar um usuario pelo put com um email ja cadastrado

#---------------CONTRATO-----------------#
Ct-Contrato-01-User-Post
    [Documentation]    Enviar cadastro de usuário com os campos documentados e um atributo extra não previsto no contrato:
    [Tags]    Contrato
    Falhar em cadastrar usuario: campo extra
Ct-Contrato-02-User-Post
    [Documentation]    Enviar cadastro de usuário sem um campo obrigatório
    [Tags]    Contrato
    Falhar em cadastrar usuario: campo faltando
#---------------NEGOCIO------------------#