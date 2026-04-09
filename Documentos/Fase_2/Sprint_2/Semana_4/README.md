## objetivo do projeto
Api Alvo:https://compassuol.serverest.dev/

O objetivo deste é criar testes automatizados para todos os endpoints (Usuários, Produtos, Carrinhos e Login) oferecendo uma cobertura de testes negativos, positivos, e validação de contrato e trazer os testes feitos no postman para este projeto


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
robot -i Positivos arquivo.robot
```

Os testes estao organizados por endpoint na qual cada case test tem um ID
voce pode verificar a documentaçao correspondente a cada ID

Todos os test cases novos tem que ter um ID por isso seguimos a seguinte estrutura para montar um ID
```
CT-Tipo de teste-Numero-Endpoint-Metodo
```
Todos os Cts devem ter exatamente a descriçao igual ao que foi escrito no plano de testes

## como visualizar evidências (reports/logs)
Após a execuçao dos teste o robotframework gera uma pasta chamada results lá voce pode encontrar o log da execução

Para visualizar reports voce deve acessar o jira
https://espacoparachallangecerto.atlassian.net/jira/software/projects/RS/boards/135
## Como o codigo funciona
Como convenção, variáveis com todas as letras em maiúsculo são tratadas como **constantes**.

### Estrutura de Pastas

#### `resources/`
A pasta `resources` centraliza todos os recursos necessários para o desenvolvimento dos testes. Ela é dividida em duas subpastas principais: `keywords` e `support`.

*   **`keywords/`**: Contém um arquivo de resource (`.robot`) para cada endpoint da API (ex: `Endpoint_Usuarios.robot`). Cada arquivo agrupa as keywords específicas para interagir com aquele endpoint.

*   **`support/`**: Fornece arquivos auxiliares que dão suporte aos testes. Está organizada nas seguintes subpastas:
    *   **`bases/`**: Armazena configurações iniciais. Por exemplo, para evitar a importação repetida do arquivo `serverest_variables.robot` em todos os testes, nós o referenciamos aqui. Dessa forma, qualquer arquivo que importe o resource de `bases` terá acesso às bibliotecas e variáveis globais.
    *   **`common/`**: Contém keywords e funcionalidades genéricas, que podem ser reutilizadas em testes de diferentes endpoints (ex: validação de schema de JSON).
    *   **`fixtures/`**: Responsável por fornecer a massa de dados para os testes.
        *   `dynamics.robot`: Gera dados dinâmicos e aleatórios para garantir a variabilidade dos testes.
        *   `static/`: Armazena arquivos JSON com dados fixos, classificados como "válidos" e "inválidos". É útil para criar um repositório de dados conhecidos, permitindo, por exemplo, retestar cenários que falharam em versões anteriores e verificar se as correções foram eficazes.
    *   **`variables/`**: Armazena o arquivo `serverest_variables.robot`, que define as variáveis globais do projeto. Variáveis como `${HOST}` são usadas em todos os endpoints e precisam estar sempre disponíveis. Este arquivo centraliza essas definições.

#### `tests/`
É onde armazenamos nossos testes automatizados, organizados por endpoints.

### Funcionamento das Keywords
Todos os arquivos de keywords de endpoint (`resources/keywords/`) importam as bibliotecas `RequestsLibrary` e `String` e definem as variáveis de rota correspondentes.

Por exemplo, o arquivo `Endpoint_Carrinhos.robot` contém:
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
