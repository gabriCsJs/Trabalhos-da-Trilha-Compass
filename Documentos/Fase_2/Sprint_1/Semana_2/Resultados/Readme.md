# Observação
Durante o desenvolvimento eu desenvolvi outra calculadora mais complexa porem como eu estava atrasado no curso de pytest eu nao consegui
desenvolver os testes dela a tempo entao optei por desenvolver essa calculadora mais basica e entregar o trabalho por isso
Este código foi desenvolvido com foco em **simplicidade e tratamento básico de erros**


# Calculadora em Python

| Requisitos do projeto  |
| :-----------: |
| Soma      |
| Subtracao      |
| multiplicacao      |
| Divisao      |
| resto |
| potenciacao |

## Descrição

Este código implementa uma **classe de calculadora** em Python chamada `calcula`.
Ela possui métodos para realizar operações matemáticas básicas entre dois valores.

Todas as operações tentam converter os valores recebidos para `float`, permitindo trabalhar tanto com **inteiros quanto números decimais**.

Caso os valores informados não possam ser convertidos para número, o programa retorna a mensagem:

```
"tipo de dado errado"
```

Algumas operações também verificam **divisão por zero**, retornando:

```
"o denominador nao pode ser 0"
```

---

# Estrutura da Classe

```
class calcula
```

A classe contém métodos responsáveis por realizar diferentes operações matemáticas.

Cada método recebe dois parâmetros:

* `a` → primeiro número
* `b` → segundo número

---

# Métodos

## 1. Divisão

```
divisao(self, a, b)
```

Realiza a divisão entre dois números.

### Regras

* Se `b` for igual a `0`, retorna erro de denominador.
* Caso os valores não possam ser convertidos para número, retorna erro de tipo.

### Exemplo

```
calc = calcula()
calc.divisao(10,2)
```

Resultado:

```
5.0
```

---

## 2. Multiplicação

```
multiplicacao(self, a, b)
```

Multiplica dois números.

### Exemplo

```
calc.multiplicacao(5,3)
```

Resultado

```
15.0
```

---

## 3. Soma

```
soma(self, a, b)
```

Realiza a soma de dois números.

### Exemplo

```
calc.soma(4,6)
```

Resultado

```
10.0
```

---

## 4. Subtração

```
subtracao(self, a, b)
```

Subtrai o segundo valor do primeiro.

### Exemplo

```
calc.subtracao(10,3)
```

Resultado

```
7.0
```

---

## 5. Resto da divisão (Módulo)

```
resto(self, a, b)
```

Retorna o **resto da divisão** entre dois números.

### Regras

* Se `b` for `0`, retorna erro de denominador.

### Exemplo

```
calc.resto(10,3)
```

Resultado

```
1.0
```

---

## 6. Potência

```
potencia(self, a, b)
```

Calcula `a` elevado a `b`.

### Exemplo

```
calc.potencia(2,3)
```

Resultado

```
8.0
```

---

# Tratamento de Erros

O código utiliza **try/except** para capturar erros de conversão de tipo.

Exemplo de erro:

```
calc.soma("a",5)
```

Resultado

```
"tipo de dado errado"
```

---

# Exemplo de Uso Completo

```
from calculadora import calcula

calc = calcula()

print(calc.soma(10,5))
print(calc.subtracao(10,5))
print(calc.multiplicacao(10,5))
print(calc.divisao(10,5))
print(calc.resto(10,5))
print(calc.potencia(2,3))
```

---

# Como vou evoluir
Irei estudar mais pytest com o objetivo de conseguir implementar os testes na minha calculadora original