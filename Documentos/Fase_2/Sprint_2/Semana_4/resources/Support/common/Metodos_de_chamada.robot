*** Settings ***
Resource     ../Variebles/serverest_variables.robot
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary

*** Keywords ***
Post
    [Arguments]    ${Rota}    ${body}    ${statuscode}    ${Authorization}=0
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    POST On Session    alias=Serverest    url=${Rota}    json=&{body}    headers=${Header}     expected_status=${statuscode}
    ${json}=    Set Variable    ${response.json()}
    ${tem_message}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${json}    message
    IF    $Rota==$ROTA_USUARIOS
        IF    ${statuscode}==201
            IF    ${tem_message}
                RETURN    ${json}[_id]    ${body}[email]    ${body}[password]    ${json}[message]
            ELSE
                RETURN    ${json}
            END
        ELSE
            IF    ${tem_message}
                RETURN    ${json}[message]
            ELSE
                RETURN    ${json}
            END
        END
    ELSE IF    $Rota==$ROTA_LOGIN
        IF    ${statuscode}==200
                RETURN  ${json}[authorization]    ${json}[message]
            ELSE
                RETURN  ${json}[message]
            END
    ELSE IF    $Rota==$ROTA_PRODUTOS
        IF    ${statuscode}==201
            RETURN    ${json}[_id]    ${json}[message]
        ELSE
            RETURN    ${json}[message]
        END
    END
    
Put
    [Arguments]    ${Rota}  ${id}  ${body}   ${statuscode}    ${Authorization}=0
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=  PUT On Session   alias=Serverest    url=${Rota}/${id}    json=&{Body}  headers=${Header}  expected_status=${statuscode}
    ${json}=    Set Variable    ${response.json()}
    IF    $Rota==$ROTA_USUARIOS or $Rota==$ROTA_PRODUTOS
        IF    ${statuscode}==201
            RETURN    ${response.json()}[_id]    ${response.json()}[message]
        ELSE
            RETURN    ${response.json()}[message]
        END
    END

DELETE
    [Arguments]    ${Rota}    ${id}    ${statuscode}    ${Authorization}=0
    &{Header}    Create Dictionary    Authorization=${Authorization}
    ${response}=    DELETE On Session    alias=Serverest    url=${Rota}/${id}  headers=${Header}  expected_status=${statuscode}
    ${json}=    Set Variable    ${response.json()}
    IF    $Rota==$ROTA_USUARIOS
        IF    ${statuscode}==400
            RETURN    ${response.json()}[idCarrinho]  ${response.json()}[message]
        ELSE
            RETURN    ${response.json()}[message]
        END
    ELSE IF    $Rota==$ROTA_PRODUTOS
        RETURN    ${response.json()}[message]
    END

GET - Listar itens cadastrados no endpoint "${endpoint}"
    ${response}=  Get On Session    alias=Serverest   url=${endpoint}
    RETURN    ${response.json()}

GET - Buscar item por ID no endpoint "${endpoint}"    
    [Arguments]      ${id}    ${statuscode}
    ${response}=  Get On Session    alias=Serverest    url=${endpoint}/${id}    expected_status=${statuscode}
    RETURN    ${response.json()}