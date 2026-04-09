*** Settings ***
Library  RequestsLibrary
Library  String
Resource    ../Support/Bases/Configuracao.resource


*** Variables ***

${ROTA_PRODUTOS}     /produtos

*** Keywords ***

#-------------PRESCISA SER REVISADO PARA GARANTIR QUE NAO EXISTEM MAIS BUGS-------------#

Cadastrar produto estatico valido
    [Arguments]    ${cenario}    ${Authorization}  ${Guardar_Var_na_Global}=${True}
    ${json}    importar JSON estatico    resources/Support/fixtures/Static/produtos.json
    ${body}    Set Variable    ${json["validos"]["${cenario}"]}
    ${id}    ${mensagem}=    Post produto   ${Authorization}    ${body}    201
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
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
    ${id}    ${mensagem}=    POST produto   ${Authorization}    ${payload}    201
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso
    IF    ${Guardar_Var_na_Global}==${True}
        Set Global Variable    ${ID_Produto}   ${id}
    ELSE
        RETURN    ${id}
    END

POST produto
    [Arguments]    ${Authorization}    ${body}    ${statuscode}
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    POST On Session    alias=Serverest    url=${ROTA_PRODUTOS}    json=&{body}    headers=${Header}    expected_status=${statuscode}
    ${body}=    Set Variable    ${response.json()}
    IF    ${statuscode}==201
        RETURN    ${response.json()}[_id]    ${response.json()}[message]
    ELSE
        RETURN    ${response.json()}[message]
    END
    


# PUT produto
#     [Arguments]    ${id}    ${Authorization}    ${body}    ${statuscode}
#     &{Header}    Create Dictionary    Authorization=${Authorization}
#     ${response}=    PUT On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id}    json=&{body}    headers=${Header}   expected_status=${statuscode}
#     IF    ${response}[message]==  Registro alterado com sucesso
#         RETURN    ${response}[message]
#     ELSE
#         RETURN    ${response}[_id]    ${response}[message]
#     END
PUT produto
    [Arguments]    ${id_produto}    ${Authorization}    ${body}    ${statuscode}
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    PUT On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id_produto}    json=&{body}    headers=${Header}    expected_status=${statuscode}
    ${body}=    Set Variable    ${response.json()}
    IF    ${statuscode}== 201
        RETURN    ${body}[_id]    ${body}[message]
    ELSE
        RETURN    ${body}[message]
    END

    
# ou

# PUT produto
#     [Arguments]    ${id}    ${Authorization}    ${body}    ${statuscode}
#     &{Header}    Create Dictionary    Authorization=${Authorization}
#     ${response}=    PUT On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id}    json=&{body}    headers=${Header}    expected_status=${statuscode}
#     IF    '${response.json()["message"]}' == 'Registro alterado com sucesso'
#         RETURN    ${response.json()["message"]}
#     ELSE
#         RETURN    ${response.json()["_id"]}    ${response.json()["message"]}
#     END

#esse carinha tem que virar generico
editar produto dinamicamente
    [Arguments]    ${id_produto}    ${Authorization} 
    ${payload}    Criar dados para produtos validos
    ${id}  ${mensagem}=  PUT produto    ${id_produto}    ${Authorization}    ${payload}    200 
    RETURN    ${id}    ${mensagem}
    # Should Be Equal    ${mensagem}   Registro alterado com sucesso
Falhar em editar produto: authorization expirada
    [Arguments]    ${authorization}=${Adm_authorization}
    Cadastrar produto dinamico valido    
    Esperar Token invalidar
    ${payload}    Criar dados para produtos validos
    ${mensagem}=  PUT produto    ${ID_Produto}    ${Authorization}    ${payload}    200 
    Should Be Equal    ${mensagem}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Sucesso em editar produto dinamicamente
    [Arguments]    ${id_produto}    ${Authorization}
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT produto    ${id_produto}    ${Authorization}    ${payload}    200
    Should Be Equal    ${mensagem}   Registro alterado com sucesso


Criar produto Dinamicamente pelo PUT Com sucesso
    [Arguments]    ${Authorization}=${Adm_authorization}    ${guardar_id}=${False} 
    ${id}=     Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${id}  ${mensagem}=  PUT produto    ${id_produto}    ${Authorization}    ${payload}    201
    IF    ${guardar_id}==${True}
        Set Global Variable    ${ID_Produto}   ${id}
    END
    Should Be Equal    ${mensagem}   Cadastro realizado com sucesso

Falhar em editar produto: ID de produto inexistente
    [Arguments]    ${Authorization_de_um_adm}=${Adm_authorization} 
    ${id_de_produto_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT produto    ${id_de_produto_falso}    ${Authorization_de_um_adm}    ${payload}    400

Falhar em editar produto: authorization invalida
    [Arguments]    ${id_de_produto}=${ID_Produto} 
    ${id_de_usuario_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT produto    ${id_de_produto}    ${id_de_usuario_falso}    ${payload}    401

Falhar em editar produto: authorization sem privilegios administrativos
    [Arguments]    ${id_de_produto}=${ID_Produto}    ${id_de_cliente}=${ID_Cliente}
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=  PUT produto    ${id_de_produto}    ${id_de_cliente}    ${payload}    403


DELETE - produto
    [Arguments]    ${id_do_produto}    ${Authorization}   ${statuscode}  
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    DELETE On Session    alias=Serverest    url=${ROTA_PRODUTOS}/${id_do_produto}    headers=${Header}
    ${body}=    Set Variable    ${response.json()}
    RETURN    ${body}[message]

Excluir produto com sucesso: Produto existente
    [Arguments]    ${id_do_produto}=${ID_Produto}    ${Authorization}=${Adm_authorization}
    ${mensagem}=  DELETE - produto    ${id_do_produto}    ${Authorization}    200
    Should Be Equal    ${mensagem}   Registro excluído com sucesso

Falhar em Excluir produto: Produto inexistente
    [Arguments]    ${Authorization}=${Adm_authorization}
    ${id_do_produto}=    Gerar id alfanumerico
    ${mensagem}=  DELETE - produto    ${id_do_produto}    ${Authorization}    200
    Should Be Equal    ${mensagem}   Nenhum registro excluído

Falhar em excluir produto: Produto faz parte de um carrinho
    [Documentation]
    [Arguments]    ${Authorization}    ${id_do_produto}
    ${mensagem}=  DELETE - produto    ${id_do_produto}    ${Authorization}    400
    Should Be Equal    ${mensagem}   Não é permitido excluir produto que faz parte de carrinho

Falhar em excluir produto: authorization invalida
    Cadastrar produto dinamico valido
    ${id_de_usuario_falso}=    Gerar id alfanumerico
    ${mensagem}=  DELETE - produto    ${ID_Produto}    ${id_de_usuario_falso}    401
    Should Be Equal    ${mensagem}   Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Falhar em excluir produto: authorization sem privilegios administrativos
    [Arguments]    ${id_do_produto}    ${Authorization_de_um_cliente}
    ${mensagem}=  DELETE - produto    ${id_do_produto}    ${Authorization_de_um_cliente}    403
    Should Be Equal    ${mensagem}   Rota exclusiva para administradores


Criar e editar produto
    [Arguments]    ${Authorization}=${Adm_authorization}
    Cadastrar produto dinamico valido
    Sucesso em editar produto dinamicamente    ${ID_Produto}    ${Authorization}

Falhar em Criar produto: authorization gerada artificialmente
    ${id_de_usuario_falso}=    Gerar id alfanumerico
    ${payload}=    Criar dados para produtos validos
    ${mensagem}=    POST produto   ${id_de_usuario_falso}    ${payload}    401
    Should Be Equal    ${mensagem}   Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    
Falhar em criar produto pelo PUT: nome de produto ja registrado
    [Arguments]    ${Authorization}=${Adm_authorization}
    ${payload}=    Criar dados para produtos validos
    Log To Console    ${payload}
    ${id}    ${mensagem}=    POST produto    ${Authorization}    ${payload}    201
    ${id_falso}=    Gerar id alfanumerico
    Log To Console    ${payload}
    Listar itens cadastrados no endpoint "${ROTA_PRODUTOS}"
    ${mensagem}=    PUT produto    ${id_falso}    ${Authorization}    ${payload}    400
    Log To Console    ${payload}
    Listar itens cadastrados no endpoint "${ROTA_PRODUTOS}"
    Should Be Equal    ${mensagem}    Já existe produto com esse nome