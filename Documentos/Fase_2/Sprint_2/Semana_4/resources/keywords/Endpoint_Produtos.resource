*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource


*** Variables ***

${MSG_CADASTRO_SUCESSO}                  Cadastro realizado com sucesso
${MSG_ALTERACAO_SUCESSO}                 Registro alterado com sucesso
${MSG_EXCLUSAO_SUCESSO}                  Registro excluído com sucesso
${MSG_NENHUM_REGISTRO_EXCLUIDO}          Nenhum registro excluído
${MSG_TOKEN_INVALIDO}                    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
${MSG_APENAS_ADMIN}                      Rota exclusiva para administradores
${MSG_PRODUTO_NO_CARRINHO}               Não é permitido excluir produto que faz parte de carrinho
${MSG_NOME_DUPLICADO}                    Já existe produto com esse nome

*** Keywords ***

#-------------PRESCISA SER REVISADO PARA GARANTIR QUE NAO EXISTEM MAIS BUGS-------------#

Cadastrar produto estatico valido
    [Arguments]    ${cenario}    ${Authorization}  ${Guardar_Var_na_Global}=${True}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/produtos.json
    ${body}    Set Variable    ${json["validos"]["${cenario}"]}
    ${id}    ${mensagem}=    Post    ${ROTA_PRODUTOS}    ${Authorization}    ${body}    201
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}
    Set Global Variable    ${ID_Produto}   ${id}
    IF    ${Guardar_Var_na_Global}==${True}
        Set Global Variable    ${ID_Produto}   ${id}
    ELSE
        RETURN    ${id}
    END

Cadastrar produto dinamico valido
    [Arguments]    ${Authorization}=${Adm_authorization}    ${Guardar_Var_na_Global}=${True}
    ${payload}=    Criar dados para produtos validos
    Log   ${payload}
    ${id}    ${mensagem}=    POST    ${ROTA_PRODUTOS}    ${payload}    201    ${Authorization}
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}
    IF    ${Guardar_Var_na_Global}==${True}
        Set Global Variable    ${ID_Produto}   ${id}
    ELSE
        RETURN    ${id}
    END

editar produto dinamicamente
    [Arguments]    ${id_produto}    ${Authorization} 
    ${payload}    Criar dados para produtos validos
    ${id}  ${mensagem}=  PUT    ${ROTA_PRODUTOS}   ${id_produto}  ${payload}   200  ${Authorization}
    RETURN    ${id}    ${mensagem}

Falhar em editar produto: authorization expirada
    [Arguments]    ${authorization}=${Adm_authorization}
    Cadastrar produto dinamico valido    
    Esperar Token invalidar
    ${payload}    Criar dados para produtos validos
    ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${ID_Produto}    ${payload}    401   ${authorization}
    Should Be Equal    ${mensagem}    ${MSG_TOKEN_INVALIDO}

Sucesso em editar produto dinamicamente
    [Arguments]    ${id_produto}    ${Authorization}
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${id_produto}    ${payload}    200   ${authorization}
    Should Be Equal    ${mensagem}   ${MSG_ALTERACAO_SUCESSO}

Criar produto Dinamicamente pelo PUT Com sucesso
    [Arguments]    ${Authorization}=${Adm_authorization}    ${guardar_id}=${False} 
    ${id}=     Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${id}  ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${id}    ${payload}  201    ${authorization}
    IF    ${guardar_id}==${True}
        Set Global Variable    ${ID_Produto}   ${id}
    END
    Should Be Equal    ${mensagem}   ${MSG_CADASTRO_SUCESSO}

Falhar em editar produto: ID de produto inexistente
    [Arguments]    ${Authorization_de_um_adm}=${Adm_authorization} 
    ${id_de_produto_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${id_de_produto_falso}    ${payload}    400   ${Authorization_de_um_adm}

Falhar em editar produto: authorization invalida
    [Arguments]    ${Authorization}=${Adm_authorization}
    ${id_de_produto}=   Cadastrar produto dinamico valido    ${Authorization}    ${False}
    ${id_de_usuario_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${id_de_produto}    ${payload}    401   ${id_de_usuario_falso}

Falhar em editar produto: authorization sem privilegios administrativos
    [Arguments]    ${id_de_produto}=${ID_Produto}    ${authorization_de_cliente}=${ID_Cliente}
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT     ${ROTA_PRODUTOS}    ${id_de_produto}    ${payload}    403   ${authorization_de_cliente}

Excluir produto com sucesso: Produto existente
    [Arguments]    ${id_do_produto}=${ID_Produto}    ${Authorization}=${Adm_authorization}
    ${mensagem}=  DELETE   ${ROTA_PRODUTOS}     ${id_do_produto}     200    ${Authorization}
    Should Be Equal    ${mensagem}   ${MSG_EXCLUSAO_SUCESSO}

Falhar em Excluir produto: Produto inexistente
    [Arguments]    ${Authorization}=${Adm_authorization}
    ${id_do_produto}=    Gerar id alfanumerico
    ${mensagem}=  DELETE   ${ROTA_PRODUTOS}     ${id_do_produto}  200  ${Authorization}    
    Should Be Equal    ${mensagem}   ${MSG_NENHUM_REGISTRO_EXCLUIDO}

Falhar em excluir produto: Produto faz parte de um carrinho
    [Documentation]     Refatorar
    [Arguments]    ${Authorization}    ${id_do_produto}
    ${mensagem}=  DELETE   ${ROTA_PRODUTOS}     ${id_do_produto}  400  ${Authorization}    
    Should Be Equal    ${mensagem}   ${MSG_PRODUTO_NO_CARRINHO}

Falhar em excluir produto: authorization invalida
    Cadastrar produto dinamico valido
    ${authorization_de_usuario_falso}=    Gerar id alfanumerico
    ${mensagem}=  DELETE   ${ROTA_PRODUTOS}     ${ID_Produto}  401  ${authorization_de_usuario_falso}    
    Should Be Equal    ${mensagem}   ${MSG_TOKEN_INVALIDO}

Falhar em excluir produto: authorization sem privilegios administrativos
    [Arguments]    ${id_do_produto}    ${Authorization_de_um_cliente}
    ${mensagem}=  DELETE   ${ROTA_PRODUTOS}     ${id_do_produto}    ${Authorization_de_um_cliente}    403
    Should Be Equal    ${mensagem}   ${MSG_APENAS_ADMIN}

Criar e editar produto
    [Arguments]    ${Authorization}=${Adm_authorization}
    Cadastrar produto dinamico valido
    Sucesso em editar produto dinamicamente    ${ID_Produto}    ${Authorization}

Falhar em Criar produto: authorization gerada artificialmente
    ${id_de_usuario_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=    POST   ${ROTA_PRODUTOS}   ${payload}   401    ${id_de_usuario_falso} 
    Should Be Equal    ${mensagem}   ${MSG_TOKEN_INVALIDO}
    
Falhar em criar produto pelo PUT: nome de produto ja registrado
    [Arguments]    ${Authorization}=${Adm_authorization}
    ${payload}=    Criar dados para produtos validos
    Log To Console    ${payload}
    ${id}    ${mensagem}=    POST   ${ROTA_PRODUTOS}   ${payload}   201    ${Authorization}
    ${id_falso}=    Gerar id alfanumerico
    Log To Console    ${payload}
    GET - Listar itens cadastrados no endpoint "${ROTA_PRODUTOS}"
    ${mensagem}=    PUT    ${ROTA_PRODUTOS}    ${id_falso}   ${payload}  400    ${Authorization}
    Log To Console    ${payload}
    GET - Listar itens cadastrados no endpoint "${ROTA_PRODUTOS}"
    Should Be Equal    ${mensagem}    ${MSG_NOME_DUPLICADO}