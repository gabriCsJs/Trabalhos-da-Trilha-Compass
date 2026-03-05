class calcula:
    def divisao(self,a,b):
        if b == 0:
            return "o denominador nao pode ser 0"
        else:
            try:
                a , b = float(a), float(b)
                total = a / b
                return total
            except ValueError:
                total = "tipo de dado errado"
                return total
    def multiplicacao(self,a, b):
        try:
            a , b = float(a), float(b)
            total = a * b
            return total
        except ValueError:
            total = "tipo de dado errado"
            return total
    def soma(self,a, b):
        try:
            a , b = float(a), float(b)
            total = a + b
            return total
        except ValueError:
            total = "tipo de dado errado"
            return total
    def subtracao(self, a,b):
        try:
            a , b = float(a), float(b)
            total = a - b
            return total
        except ValueError:
            total = "tipo de dado errado"
            return total
    def resto(self, a,b):
        if b == 0:
            return "o denominador nao pode ser 0"
        else:
            try:
                a , b = float(a), float(b)
                total = a % b
                return total
            except ValueError:
                total = "tipo de dado errado"
                return total
    def potencia(self, a,b):
        try:
            a , b = float(a), float(b)
            total = a ** b
            return total
        except ValueError:
            total = "tipo de dado errado"
            return total