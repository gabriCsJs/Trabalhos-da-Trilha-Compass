*** Settings ***
Resource     ../Variebles/serverest_variables.robot
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary

*** Keywords ***

Validar estrutura do JSON
    [Arguments]    ${resposta}    @{chaves_esperadas}
    FOR    ${chave}    IN    @{chaves_esperadas}
        Dictionary Should Contain Key    ${resposta}    ${chave}
    END

Validar status code
    [Arguments]    ${resposta}    ${statuscode}
    Should Be True    ${resposta.status_code} == ${statuscode}

# Validar quantidade "${quantidade}"
    
Listar itens cadastrados no endpoint "${endpoint}"
    ${response}=  Get On Session    alias=Serverest   url=${endpoint}
    RETURN    ${response.json()}

Buscar item por ID no endpoint "${endpoint}"    
    [Arguments]      ${id}    ${statuscode}
    ${response}=  Get On Session    alias=Serverest    url=${endpoint}/${id}    expected_status=${statuscode}
    RETURN    ${response.json()}

importar JSON estatico
    [Arguments]    ${nome_arquivo}
    ${arquivo}    Get File  ${EXECDIR}/${nome_arquivo}
    ${data}    Evaluate    json.loads('''${arquivo}''')    json
    RETURN    ${data}

Validar campos do payload de usuario
    [Arguments]    ${payload}
    @{campos_esperados}    Create List    nome    email    password    administrador
    ${campos_recebidos}=    Get Dictionary Keys    ${payload}

    FOR    ${campo}    IN    @{campos_esperados}
        ${presente}=    Run Keyword And Return Status    List Should Contain Value    ${campos_recebidos}    ${campo}
        IF    not ${presente}
            RETURN    campo_faltando:${campo}
        END
    END

    FOR    ${campo}    IN    @{campos_recebidos}
        ${esperado}=    Run Keyword And Return Status    List Should Contain Value    ${campos_esperados}    ${campo}
        IF    not ${esperado}
            RETURN    campo_extra:${campo}
        END
    END

    RETURN    ${None}


Esperar Token invalidar
    Sleep    600
