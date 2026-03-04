import pytest
from calculadora import calcula

@pytest.mark.parametrize("a,b,total", [
    (10,2,5),
    (9,0,"o denominador nao pode ser 0"),
    (8,1,8)
])
def test_divisao(a,b,total):
    calc = calcula()
    assert calc.divisao(a,b) == total
'''
def test_multiplicacao(a,b,total):
    calc = calcula()
    assert calc.multiplicacao(a,b) == total
def test_divisao(a,b,total):
    calc = calcula()
    assert calc.divisao(a,b) == total
def test_divisao(a,b,total):
    calc = calcula()
    assert calc.divisao(a,b) == total
'''    