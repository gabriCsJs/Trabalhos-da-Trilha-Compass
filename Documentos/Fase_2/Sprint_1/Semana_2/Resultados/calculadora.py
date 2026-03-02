def verifica(primeiroValor=False, denominadorDivisao=False):
    m1 = "insira um valor(exit para sair): "
    m2 = "insira o primeiro valor(exit para sair): "
    if primeiroValor == True: 
        mensagem = m2 
    else: 
        mensagem = m1
    while True:
        while True: #forca o usuario a digitar algo
            UserTerminal = input(mensagem).lower()
            if not UserTerminal.strip(): #se nao tem nada
                print("voce nao digitou um valor")
            else:
                #return UserTerminal
                break
        if primeiroValor == False or UserTerminal == "exit": #verifica se é primeiroValor ou se é o comando exit para sair
            if UserTerminal in ["exit", "apagar", "visualizar", "status"]: 
                return UserTerminal
                #break
        try: #verifica se é um numero
            a = float(UserTerminal)
            if denominadorDivisao == True:
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
            valor = verifica(primeiroValor=False, denominadorDivisao=True)  #adiconar valor

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
        soma()
    elif resposta == "imc":
        soma()
    elif resposta == "exit":
        break