class calculadora:
    def divisao(self,a,b):
        if b == 0:
            return "o denominador nao pode ser 0"
        else:
            total = a // b
            return total
    def multiplicacao(self,a, b):
        total = a * b
        return total
    def soma(self,a, b):
        total = a + b
        return total
    def subtracao(self, a,b):
        total = a - b
        return total
    def resto(self, a,b):
        if b == 0:
            return "o denominador nao pode ser 0"
        else:
            total = a % b
            return total
    def potencia(self, a,b):
        total = a ** b
        return total