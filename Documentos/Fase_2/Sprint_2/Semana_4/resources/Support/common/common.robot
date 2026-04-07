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
