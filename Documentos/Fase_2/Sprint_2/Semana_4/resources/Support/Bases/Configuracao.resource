*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Library    OperatingSystem
Resource    ../Variebles/serverest_variables.robot
Resource    ../common/common.robot
Resource    ../fixtures/dynamics.robot
Resource    ../common/Metodos_de_chamada.robot


*** Keywords ***
Iniciar Sessao API
    [Documentation]    Cria a sessão principal da Serverest
    Create Session    alias=Serverest    url=${HOST}    disable_warnings=True
Encerrar Sessao API
    Delete All Sessions