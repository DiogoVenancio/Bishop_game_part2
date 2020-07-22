# 1. Inteligência Artificial
## **JOGO DO BISPO - PARTE 2**

![alt text](https://pcatunda.files.wordpress.com/2014/06/xadrez.jpg "IA imagem")

### **Docente:**

- Filipe Mariano

### **Alunos:**

- Diogo Venâncio - 160221076
- André Gonçalves - 170221015

<br>

# **Indíce**

- [Objetivo do programa](#objetivo-do-programa)
- [Funcionamento](#funcionamento)
	- [Menu inicial](#menu-inicial)
	- [Menu Humano vs PC](#menu-humano-vs-pc)
	- [Menu do tempo de processamento](#menu-do-tempo-de-processamento)
	- [Menu da 1º jogada](#menu-da-1º-jogada)
  - [Menu dos movimentos](#menu-dos-movimentos)
- [Estatística](#estatística)
- [Limitações do programa](#limitações-do-programa)

<br>

# **Objetivo do programa**

Este programa tem como objetivos:

1. Ser possivel jogar entre um humano vs pc;
2. Ser possivel jogar entre pc vs pc;
3. Ser possivel selecionar quando efetua a 1ª jogada;
4. As estatísticas ficarem registadas num ficheiro.

<br>

# **Funcionamento**

## **Menu inicial**

No menu inicial o jogador escolhe qual o tipo de jogo que pretende

```lisp
 -------------------------------------
              Jogo do Bispo            
                                       
            1 - Humano vs PC           
              2 - PC vs PC             
                                       
                s - Sair               
 -------------------------------------
```

---

## **Menu Humano vs PC**

No menu do jogo Humano vs PC o jogador escolhe se quer efetuar a primeira jogada ou não

```lisp
 --------------------------------------------------
  Jogo do Bispo - Escolha quem inicia a 1ª jogada  
                                                   
                   1 - Humano                      
                    2 - PC                         
                                                   
                   s - Sair                        
 ---------------------------------------------------
```

---

## **Menu do tempo de processamento**

No menu do tempo de processamento o jogador escolhe qual o valor que quer atribuir para o tempo de processamento.

```lisp
 ---------------------------------------------------------
  Jogo do Bispo - Insira o tempo limite de processamento  
                 (Entre 1 a 5 segundos)                   
                                                          
                       s - Sair                           
 ---------------------------------------------------------
```

---

## **Menu da 1º jogada**

No menu da 1º jogada o jogador escolhe a coluna que quer jogar o seu bispo

```lisp
   (37 62 55 31 73 58 51 47)
   (35 44 38 12 41 83 74 68)
   (36 33 24 27 18 75 88 61)
   (54 43 32 34 81 78 87 77)
   (56 13 15 86 42 71 21 46)
   (85 28 45 11 64 14 63 22)
   (17 57 16 66 82 47 72 48)
   (53 67 23 76 25 84 65 26)

Escolha uma coluna da 1ªlinha para colocar o bispo - 
```

---

## **Menu dos movimentos**

No menu dos movimentos o jogador escolhe qual o valor da casa que pretende jogar o bispo

```lisp

   (37 62 -1 31 73 58 51 47)
   (35 44 38 12 41 83 74 68)
   (36 33 24 27 18 75 88 61)
   (54 43 32 34 81 78 87 77)
   (56 13 15 86 42 71 21 46)
   (85 28 45 11 64 14 63 22)
   (17 57 16 66 82 47 72 NIL)
   (53 67 23 76 25 -2 65 26)

   Pontos Jogador 2 (PC): 84
   Nº de Nos: 6372 
   Nº Cortes: 1205 
   Tempo Execução: 1017

 --------------------------------------------
 Jogo do Bispo - Escolha a proxima posicao  
                                            
         1 - Posicao com valor 44                 
         2 - Posicao com valor 36                 
         3 - Posicao com valor 12                 
         4 - Posicao com valor 18                 
         5 - Posicao com valor 78                 
         6 - Posicao com valor 21                 
         7 - Posicao com valor 22                 
                                        
 -------------------------------------
```

## **Estatística**

No final de um jogo, é mostrado para o ecrã os pontos totais de cada jogador

Exemplo: PC VS PC

> Ecrã

```lisp
---------------------------
                           
        Fim do Jogo        
                           
---------------------------
Pontos Jogador 1: 2407
Pontos Jogador 2: 3804
```

> Ficheiro log.dat

```lisp
---------------------------------------
        PC VS PC        
-------------------------------------
Pontos Jogador 1: 2407
Pontos Jogador 2: 3804
```

<br>

# **Limitações do programa**

1. Quando o jogador não consegue efetuar mais jogadas, ás vezes a mensagem de fim de jogo não aparece.