def verifica(primeiroValor=False, Bloqueia0=False,Imc = str):
    if primeiroValor == True: 
        mensagem = "insira o primeiro valor(exit para sair): " 
    else: 
        mensagem = "insira um valor(exit para sair): "
    if Imc == "peso":
        mensagem = "insira o seu peso"
    elif Imc == "altura":
        mensagem = "insira a sua altura"
    while True:
        while True: #forca o usuario a digitar algo
            UserTerminal = input(mensagem).lower()
            if not UserTerminal.strip(): #se nao tem nada
                print("voce nao digitou um valor")
            else:
                #return UserTerminal
                break
        if "," in UserTerminal:
            UserTerminal = UserTerminal.replace(",", ".")
        if primeiroValor == False or UserTerminal == "exit": #verifica se é primeiroValor ou se é o comando exit para sair
            if UserTerminal in ["exit", "apagar", "visualizar", "status"]: 
                return UserTerminal
                #break
        try: #verifica se é um numero
            a = float(UserTerminal)
            if Bloqueia0 == True:
                if a == 0:
                    print("nao e possivel dividir por zero tente novamente")
                    continue
            return a
        except ValueError:
            print("parece que voce nao digitou um numero!")
            continue

def soma():
    total = 0
    while True:    
        #Verificacao
        valor = verifica()

        if valor == "exit":
            print(f"o valor final é: {total}")
            break
        elif valor == "apagar":
            total = 0
            continue
        elif valor == "visualizar" or valor == "status":
            print(f"valor da soma atual é: {total}")
        else:
                total += valor

def subtracao():
    while True:
        #inicializa
        primeiroValor = verifica(True)
        total = 0
        frist = True
        #valor = verifica(False, True)
        while True:
            #Verificacao
            valor = verifica(False, True)  #adiconar valor

            if valor == "exit":
                print(f"o valor final é: {total}")
                break
            elif valor == "apagar":
                frist = True
                total = 0
                primeiroValor = verifica(True)
                continue
            elif valor == "visualizar" or valor == "status":
                print(f"valor da subtracao atual é: {total}")
            else: #faz operacao
                if frist == True:
                    total = primeiroValor - valor
                    frist = False
                else:
                    total -= valor
        break

def multiplicacao():
    total = 0
    while True:    
        #Verificacao
        valor = verifica()

        if valor == "exit":
            print(f"o valor final é: {total}")
            break
        elif valor == "apagar":
            total = 0
            continue
        elif valor == "visualizar" or valor == "status":
            print(f"valor da soma atual é: {total}")
        else:
                total *= valor

def divisao():
    while True:
        #inicializa
        primeiroValor = verifica(True, False)
        total = 0
        frist = True
        while True: #inifinidade
            #Verificacao
            valor = verifica(primeiroValor=False, Bloqueia0=True)  #adiconar valor

            if valor == "exit":
                print(f"o valor final é: {total}")
                break
            elif valor == "apagar":
                frist = True
                total = 0
                primeiroValor = verifica(True)
                continue
            elif valor == "visualizar" or valor == "status":
                print(f"valor da soma atual é: {total}")
            else: #faz operacao
                if frist == True:
                    total = primeiroValor / valor
                    frist = False
                else:
                    total /= valor
        break
def imc():
    peso = verifica(primeiroValor=False, Bloqueia0=True,Imc="peso")
    altura = verifica(primeiroValor=False, Bloqueia0=True,Imc="altura")
    ImcReal = peso / (altura **2)
    total = round(ImcReal,2)
    if total < 17:
        print("muito abaixo do peso")
    elif total < 18.5:
        print("abaixo do peso")
    elif total < 25:
        print("peso normal")
    elif total < 30:
        print("acima do peso")
    elif total < 35:
        print("obesidade I")
    elif total < 40:
        print("obesidade II")
    else:
        print("obesidade III")
    print(f"seu Imc é:{total}")

def Jcompostos():
    print("")

while True:
    resposta = input("selecione uma operacao(soma, subtracao, divisao, multiplicacao, juros compostos, imc) ou exit para sair: ").lower()

    if resposta == "soma":
        soma()
    elif resposta == "subtracao":
        subtracao()
    elif resposta == "divisao":
        divisao()
    elif resposta == "multiplicacao":
        multiplicacao()
    elif resposta == "juros compostos":
        Jcompostos()
    elif resposta == "imc":
        imc()
    elif resposta == "exit":
        break