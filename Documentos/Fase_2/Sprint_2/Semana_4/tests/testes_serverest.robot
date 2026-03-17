*** Settings ***
Resource  ../resources/Base/setup_teardown.resource
Suite Setup       Run Keywords    Iniciar Sessao API    AND    Criar Massa de Dados da Suite
Suite Teardown    Run Keywords    Limpar Massa de dados    AND    Encerrar Sessao API


*** Test Cases ***

Caso de teste 01 - Positivo
Caso de teste 02 - Negativo
Caso de teste 03 - Contrato