import pytest
from calculadora import calcula

@pytest.mark.parametrize("a,b,esperado", [
    (10.00,2,5), #deve dar certo
    (9,0,"o denominador nao pode ser 0"), #deve tratar o erro
    (8.05,5,1.61), #ponto flutuante
    ("eu sou um intruso",1.05,"tipo de dado errado")
])
def test_divisao(a,b,esperado):
    calc = calcula()
    assert calc.divisao(a,b) == esperado

@pytest.mark.parametrize("a,b,esperado", [
    (10.00,2,0.0),
    (9,0,"o denominador nao pode ser 0"),
    (8,1.00,0.0),
    ("eu sou um intruso",1.05,"tipo de dado errado")
])
def test_resto(a,b,esperado):
    calc = calcula()
    assert calc.resto(a,b) == esperado

@pytest.mark.parametrize("a,b, esperado", [
    (10.00,10,100),
    (-20,20,-400),
    (8,5.00,40.00),
    ("eu sou um intruso",1.05,"tipo de dado errado")
])
def test_multiplicacao(a,b,esperado):
    calc = calcula()
    assert calc.multiplicacao(a,b) == esperado

@pytest.mark.parametrize("a,b, esperado",[
    (10,10,20),
    (3,7,10),
    (-7.00,35,28),
    ("eu sou um intruso",1.05,"tipo de dado errado")
])
def soma(a,b,esperado):
    calc = calcula()
    assert calc.soma(a,b) == esperado

@pytest.mark.parametrize("a,b, esperado",[
    (10,90,-80),
    (3,7,-4),
    (35.00,7,28),
    ("eu sou um intruso",1.05,"tipo de dado errado")
])
def test_subtracao(a,b,esperado):
    calc = calcula()
    assert calc.subtracao(a,b) == esperado