def SuperVerifica(Bloqueia0=False, msg="insira um valor(exit para sair): "):

        #vou verificar se o usuario digitou algo | se o usuario nao digitou algo vou prender ele num loop até ter o valor
    #se for comando eu vou retornar para calculo e ele vai tratar
    #se for numero vou tratar o "," para "."
    #se for 0 vou dar um Continue para voltar la pra cima

    #depois retorno o valor para calculo

    #vou receber um valor de calculo denovo
    #e o parametro se devo bloquear 0 porque denominador nem sempre pode ser 0 
    #------------ja codificado-----------------------
    #vou verificar se o usuario digitou algo | se o usuario nao digitou algo vou prender ele num loop até ter o valor
    #se for comando eu vou retornar para calculo e ele vai tratar
    #se for numero vou tratar o "," para "."
    #se for 0 vou dar um Continue para voltar la pra cima
    #vou retornar para calculo

    #------------codificacao------------

    #vou verificar se o usuario digitou algo | se o usuario nao digitou algo vou prender ele num loop até ter o valor
    while True:
        tratamento = input(msg).strip().lower() #agora eu sei que o usuario digitou algo
        if not tratamento:
            print("voce nao colocou nada")
            continue
    #se for comando eu vou retornar para calculo e ele vai tratar
        elif tratamento in  ["exit", "status", "apagar", "apagar operacao"]: #agora eu sei se é tratamento ou nao
            return tratamento
            #se for numero vou tratar o "," para "."
        if "," in tratamento: #ja tratei o erro do usuario
                tratamento = tratamento.replace(",", ".")
        try: #verifica se é um numero
            tratamento = float(tratamento)
            if Bloqueia0 == True: #ja bloqueia o zero e mandei ele la pra cima
                if tratamento == 0:
                    print("o denominador nao pode ser 0")
                    continue
            return tratamento #retorna o numero para o calculo
        except ValueError:
            print("parece que voce nao digitou um numero!")

def SuperCalculo(operacao):
    #eu vou receber a operacao que a interface me enviou e vou definir se ele bloqueia 0 ou nao
    #eu vou pedir para o verifica receber o numero ou comando e | o paramentro bloqueia0 vai ser falso

    #recebi o valor de verefica
    #total vai gsuardar isso
    #se for um comando vou executalo
    #vou prender um usuario em um loop para receber nova entradas 
    #eu vou pedir para o verifica receber o numero ou comando e | se esta operaçao prescisa bloquear o zero eu vou mandar para o verifia mandando ele bloquear o zero

    #recebi o valor de verefica
    #vou pedir para Valor guardar
    #vou indetificar que operaçao que é e vou fazer o comando Total Operacao Valor e o resultado vai ser atribuido a Total

    #quando o usuario parar vou retornar o valor para ele

    #-----------CODIFICACAO-------------

    #eu vou pedir para o verifica receber o numero ou comando e | o paramentro bloqueia0 vai ser falso
    i = 1
    while i == 1:
        resposta = SuperVerifica(False, "insira o primeiro valor(exit para sair): ")
        #recebi o valor de verefica
        #total vai guardar isso
        #se for um comando vou executalo
        if resposta == "exit":
            break
        elif resposta == "apagar":
            continue
        else:
            total = resposta
        if operacao == "/":
            denominador = True
        else:
            denominador = False
        while True:
            resposta = SuperVerifica(denominador, "insira um outro valor(exit para sair): ")
            if resposta == "exit":
                print(f"o resultado da operacao e: {total}")
                i = 0
                break
            elif resposta == "status":
                print(f"o total no momento e: {total}")
            elif resposta == "apagar":
                continue
            elif resposta == "apagar operacao":
                break
            else:
                if operacao == "+":
                    total += resposta
                elif operacao == "-":
                    total -= resposta
                elif operacao == "*":
                    total *= resposta
                elif operacao == "/":
                    total /= resposta

    #vou apresentar as opçoes de calculos ao usuario
    #ele vai me retornar um comando e eu vou enviar para o calculo
    #se ele escrever algo errado nao tem problema estamos em um loop se ele digitar algo errado é só dizer else opçao invalida
while True:
    resposta = input("selecione uma operacao(+, - *, /, juros compostos, imc) ou exit para sair: ").lower()

    if  resposta in ["+", "-", "*", "/"]:
        SuperCalculo(resposta)
    elif resposta == "exit":
        break
    else:
        print("voce nao digitou uma operacao")
