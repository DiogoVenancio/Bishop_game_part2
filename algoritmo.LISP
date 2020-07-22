;; Contem a implementação dos algoritmos de procura
;; Autor: Diogo Venâncio - 160221076
;; Autor: André Gonçalves - 170221015
;; Ano letivo 19/20

;******* Nó *******

;Função para criar a estrutura de dados para um no
(defun create-no (board pai &optional (f 0))
  (list board pai f)
)

;Função para criar a estrutura de um no solucao
;(get-internal-real-time) - retorna um único numero inteiro no formato internal time
(defun create-no-solucao(no nos-vistos cortes time)
  (list no (list nos-vistos cortes (- (get-internal-real-time) time)))
)

;Função que retorna o estado board de um no
(defun estado-no(no)
  (first no)
)

;Função que retorna o no pai de um no
(defun pai-no(no)
  (second no)
)

;Função que retorna o valor f de um no
(defun f-no(no)
  (third no)
)

;Função que calcula a profundidade de um no
(defun profun-no(no)
  (cond
   ((null (pai-no no)) 0)
   (t (1+ (profun-no (pai-no no)))))
)

;**** FUNÇÕES ALGORITMOS ****

;Função para calcular o valor de f
(defun f-calcula-best(a b)
    (if (> a b) a b)
)

;Função que retorna uma jogada
(defun get-jogada(no &optional sucessor)
  (cond
   ((null (pai-no no)) sucessor)
   (t (get-jogada (pai-no no) no)))
)

;****** AUXILIARES ALGORITMO ******

;Função auxiliar para organizar os nos com menor valor
;;(quicksort-menor (sucessores (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board))) 50)
(defun quicksort-menor(lista valor-f)
  (cond
   ((or (null lista) (null valor-f)) nil) ;Se a lista de sucessores estiver vazia ou valor de f vazio

   ;Se o valor de f for menor que o valor do sucessor na cabeça da lista, chama recursivamente a função novamente para o resta da lista
   ((< valor-f (f-no (car lista))) (quicksort-menor (cdr lista) valor-f)) 

   ;Caso contrário, adiciona o sucessor a uma lista e chama recursivamente a função para percorrer o resto da lista
   (t (cons (car lista) (quicksort-menor (cdr lista) valor-f)))) 
)

;Função auxiliar para organizar os nos com maior valor
;;(quicksort-maior (sucessores (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board))) 50)
(defun quicksort-maior(lista valor-f)
  (cond
   ((or (null lista) (null valor-f)) nil) ;Se a lista de sucessores estiver vazia ou valor de f vazio

   ;Se o valor de f for maior ou igual que o valor do sucessor na cabeça da lista, chama recursivamente a função novamente para o resta da lista
   ((>= valor-f (f-no (car lista))) (quicksort-maior (cdr lista) valor-f))

   ;Caso contrário, adiciona o sucessor a uma lista e chama recursivamente a função para percorrer o resto da lista
   (t (cons (car lista) (quicksort-maior (cdr lista) valor-f))))
)  
 
;Função responsável por aplicar o quicksort na lista de nos sucessores 
;;(sucessores-order-negamax (sucessores (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board))) -1)
(defun sucessores-order-negamax(lista jogador)
  (cond
   ((null lista) nil) ;Se a lista de sucessor estiver vazia
   ((= jogador -1)
    (append 
     (sucessores-order-negamax (quicksort-menor (cdr lista) (f-no (car lista))) jogador) 
     (cons (car lista) nil) 
     (sucessores-order-negamax (quicksort-maior (cdr lista) (f-no (car lista))) jogador)))
   (t (append 
       (sucessores-order-negamax (quicksort-maior (cdr lista) (f-no (car lista))) jogador) 
       (cons (car lista) nil) 
       (sucessores-order-negamax (quicksort-menor (cdr lista) (f-no (car lista))) jogador))))
)
   
;****** ALGORITMO ******

;NEGAMAX - FAIL-HARD
;1. Guardar a lista de sucessores ordenados por ordem crescente a partir do no recebido e dependendo do jogador
;2. Se a profundidade for igual a 0, a lista de sucessor estiver vazia e o tempo inicial de processamento for maior ou igual ao tempo limite, cria no solução
;3. Caso contrário, chama a função auxiliar do negamax para os sucessores de um no.

;SUCESSORES NEGAMAX
;1. Se o size dos sucessores for igual a 1, chama a função do negamax com o no da lista de sucessores, trocando o jogador, alterando a profundidade, o valor de alfa e beta, e adicionando +1 aos nos gerados
;2. Guarda o no solucao com os respetivos dados: no, nos gerados, cortes e tempo
;3. Guarda o no
;4. Guarda o melhor valor de f entre o valor do no solucao e o no pai
;5. Guarda o novo valor para alfa entre o maior valor entre o valor atual de alfa e o melhor valor de f
;6. Se o novo valor de alfa for maior ou igual ao valor do beta, faz o corte e cria o no solução
;7. Caso contrário, chama a função recursivamente com:
;        no pai,
;        o resto da lista de sucessores,
;        tempo limite, 
;        função dos sucessores,
;        o jogador, 
;        o novo valor de alfa, 
;        valor de beta, 
;        tempo inicial, 
;        o valor de nos gerados até ao no solução,
;        o valor de cortes até ao no solução

;Função que executa o algoritmo negamax para um no
;;(negamax (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board)) 2000 'sucessores)
(defun negamax(no time-limite sucessor &optional (jogador -1) (profun 50) (alfa most-negative-fixnum) (beta most-positive-fixnum) 
                  (time-inicial (get-internal-real-time)) (nos-gerados 0) (cortes 0))
  (let* ((lista (posicoes-jogadas-possiveis (jogadas-possiveis (estado-no no) jogador) (estado-no no)))
        (sucessores (sucessores-order-negamax (funcall sucessor no jogador lista) jogador)))
    (cond
     ((or (= profun 0) (null sucessores) (>= (- (get-internal-real-time) time-inicial) time-limite))
      (create-no-solucao no nos-gerados cortes time-inicial))
     (t (sucessores-negamax no sucessores time-limite sucessor jogador profun alfa beta time-inicial nos-gerados cortes))))
)

;Função que executa o algoritmo negamax para os sucessores de um no
;Quicksort ajuda nos cortes
(defun sucessores-negamax(no sucessores time-limite sucessor jogador profun alfa beta time-inicial nos-gerados cortes)
  (cond
   ((= (length sucessores) 1)
    (negamax (car sucessores) time-limite sucessor (muda-jogador jogador) (1- profun) (- alfa) (- beta) time-inicial (1+ nos-gerados) cortes))
   (t (let* ((solucao (negamax (car sucessores) time-limite sucessor (muda-jogador jogador) (1- profun) (- alfa) (- beta) time-inicial (1+ nos-gerados) cortes))
             (top-no (car solucao))
             (best-valor (f-calcula-best (f-no top-no) (f-no no)))
             (alfa-novo (max alfa best-valor)))
        ;A procura pode ser descontinuada abaixo de qualqer no MAX com o valor alfa >= beta de qualquer dos seus antecessores MIN (corte beta)
        (if (>= alfa-novo beta) ;Efetua o corte
          (create-no-solucao no (nth 0 (cadr solucao)) (1+ (nth 1 (cadr solucao))) time-inicial)
         (sucessores-negamax no (cdr sucessores) time-limite sucessor jogador profun alfa-novo beta time-inicial (nth 0 (cadr solucao)) (nth 1 (cadr solucao)))))))
) 
          
   
    
   