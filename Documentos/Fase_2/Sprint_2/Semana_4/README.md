## objetivo do projeto
Api Alvo:https://compassuol.serverest.dev/

O objetivo deste plano é criar testes automatizados para todos os endpoints (Usuários, Produtos, Carrinhos e Login) oferecendo uma cobertura de testes negativos, positivos, e validação de contrato e trazer os testes feitos no postman para este projeto


## como instalar dependências

O projeto usa a RequestsLibrary, para instalar execute o seguinte comando no terminal

```
pip install robotframework-requests
```

## como executar os testes
Para executar todos os teste no arquivo clique na tecla F5
para executar um teste especifico execute o seguinte comando no terminal
```
robot -t "Nome do Teste" testes_serverest.robot
```
Para executar apenas testes com um tag especifica
```
robot -i login arquivo.robot
```

é importante verificar se a sessao settings está criada corretamente pois é nescessario uma massa de dados para a execução dos testes

```
*** Settings ***
Resource  ../resources/Base/setup_teardown.resource
Suite Setup       Run Keywords    Iniciar Sessao API    AND    Criar Massa de Dados da Suite
Suite Teardown    Run Keywords    Limpar Massa de dados    AND    Encerrar Sessao API
Library    Collections
```

Caso deseje criar sua propria massa de dados é recomendavel criar o seguintes itens na massa de dados
- Crie um Administrador e salve sua Authorization
- Crie um Cliente(usuario sem previlegios administrativos) e salve sua Authorization


voce pode executar qualquer cenario isoladamente se desejar pois a automatizaçao ja esta preparada para isso

## como visualizar evidências (reports/logs)
Após a execuçao dos teste o robotframework gera uma pasta chamada results lá voce pode encontrar o log da execução

Para visualizar reports voce deve acessar o jira
https://espacoparachallangecerto.atlassian.net/jira/software/projects/RS/boards/135
## Como o codigo funciona
Por boas praticas todas as variaveis que tiverem todas as letras em maisculo serao CONSTANTE
### arquivo configuracao
O arquivo configuracao é o responsavel por 
- armazenar todas as variaveis que iremos usar com frequencia ao decorrer dos testes
- Importar todas as keywords que serao usadas no projeto
- Iniciar, encerrar sessao da api
- Gerar e limpar massa de dados

### endpoints
Todos os endpoints tem uma sessao settings e eles importam as seguintes bibliotecas
```
RequestsLibrary
String
```
Todos os endpoints tem na sua sessao de variaveis uma varivel para sua rota

por exemplo: No arquivo  Endpoint_Carrinhos temos 3 variaveis
```
*** Variables ***
${ROTA_CARRINHOS}                 /carrinhos
${ROTA_CONCLUIR_COMPRA}           /carrinhos/concluir-compra
${ROTA_CANCELAR_COMPRA}           /carrinhos/cancelar-compra
```
quando mandamos o seguinte comando ou um similar o ```alias=Serverest``` se junta com ```url=${ROTA_CARRINHOS}```

 e obtemos o seguinte valor ```https://compassuol.serverest.dev/carrinhos```
```
${response}=  POST On Session    alias=Serverest     url=${ROTA_CARRINHOS}    json=&{Body}  headers=${Header}  expected_status=${Status_Code}
```
Ultilizamos essa técnica para todos as keywords.

todas as keywords tem um argurmento que é o ${Status_Code} e por padrao elas esperam que o teste retorne Status_Code sucesso
Se a keyword retorna uma resposta da api essa keyword nao ira retornar um json se o Status Code recebido for de falha isso foi feito para evitar erros na automaçao