;; C�digo relacionado com o problema
;; Autor: Diogo Ven�ncio - 160221076
;; Autor: Andr� Gon�alves - 170221015
;; Ano letivo 19/20

;******************* BOARD *******************

;Retorna a lista reverse
;;(get-board-reverse (jogar-board))
(defun get-board-reverse (board)
  (cond
   ((null board) nil)
   (t (append (get-board-reverse (cdr  board)) (list (car board)))))
)

;******************* SELECTORES *******************

;Retornar uma linha do tabuleiro
;;(get-linha 1 (jogar-board))
(defun get-linha (i board)
  (cond
   ((null board) nil)
   ((equal i 1) (car board))
  (t (get-linha (1- i) (cdr board)))
 )
)

;Retorna uma celula segundo a linha, a coluna e o board
;;(get-celula 1 2 (jogar-board))
(defun get-celula (x y board)
  (cond
   ((null board) nil)
   (t (labels ((num (i l)
                 (cond
                  ((null l) nil)
                  ((equal i 1) (car l))
                  (t (num (1- i) (cdr l))))))
        (num y (get-linha x  board)))))
)

;******************* POSICIONAMENTO *******************

;Fun��o que recebe um indice, uma lista e um valor e substitui pelo valor pretendido nessa posi��o
;;(substitui-pos 2 (get-linha 1 (jogar-board)) T)
(defun substitui-pos (x l &optional (v nil))
  (cond
   ((null l) nil)
   ((equal x 1) (cons v (cdr l)))
   (t (cons (car l) (substitui-pos (- x 1) (cdr l) v)))
   )
)

;Fun��o que recebe dois indices, o board e um valor. Retorna o board com a celula substituida pelo valor pretendido
;;(substituir 1 2 (jogar-board) T)
(defun substituir(x y board &optional (v nil))
  (cond
   ((or (null board)) nil)
   ((equal x 1) (cons (substitui-pos y (car board) v)
    (substituir (- x 1) y (cdr board) v)))
   (t (cons (car board) (substituir (- x 1) y (cdr board) v)))
   )
)

;Fun��o que verifica se a posi��o recebida est� dentro dos limites do board e retorna o valor que se encontra na casa
;;(verifica-pos 1 1 (jogar-board))
(defun verifica-pos(x y board)
  (if
   (and (>= x 0) (<= x (length board)) (>= y 0) (<= y (length board)) (not (null board)))
    (nth (- y 1) (nth (- x 1) board)) nil)
)

;Fun��o que recebe o valor a pesquisar e a linha ao qual ele se encontra. Retorna o numero da coluna
;;(get-coluna-valor 54 (get-linha 3 (jogar-board)))
(defun get-coluna-valor(v linha &optional (y 1))
  (cond
   ((null linha) nil)
   ((equal v (car linha)) y)
   (t (get-coluna-valor v (cdr linha) (1+ y))))
)

;Fun��o que recebe um valor e um board. Retorna a posicao(x y) do valor introduzido
;;(get-valor-pos 45 (jogar-board))
(defun get-valor-pos(v board &optional (x 1))
  (let ((valor-y (get-coluna-valor v (car board))))
  (cond
   ((null board) nil)
   ((null valor-y) (get-valor-pos v (cdr board) (1+ x)))
   (t (cons x (cons valor-y nil))))
   )
)

;Fun��o que retorna o maior valor de uma linha dada
;;(melhor-valor (get-valor-linha (jogar-board)))
(defun melhor-valor(linha &optional (maior 0))
  (cond
   ((null linha) maior)
   (t (let ((valor (car linha)))
     (cond
      ((null valor) nil)
      ((> valor maior) (melhor-valor (cdr linha) valor))
      (t (melhor-valor (cdr linha) maior))))))
)
   
;Fun��o que verifica se o bispo est� no tabuleiro. Se sim retorna a sua posi��o
(defun posicao-jogador(board jogador)
   (cond
   ((null board) nil)
   ((null (find jogador (car board))) (posicao-jogador (cdr board) jogador))
   (t (list (+ (- (length (car board)) (length board)) 1) (+ (- (length (car board)) (length (member jogador (car board)))) 1))))
)

;Fun��o para mudar de jogador
;;(muda-jogador -1)
(defun muda-jogador(jogador)
   (if (equal jogador -1)
       -2
     -1)
)

;Fun��o respons�vel em colocar o bispo no board
;;(coloca-jogador (create-no (jogar-board) nil) -1)
(defun coloca-jogador(no jogador)
  (let* ((bispo-pos (posicao-jogador (estado-no no) jogador))
         (linha (if(= jogador -1) 1 (length (estado-no no))))
        (melhor (melhor-valor (get-linha linha (estado-no no))))
        (bispo-pos-y (get-coluna-valor melhor (get-linha linha (estado-no no))))
        (pos (verifica-pos linha bispo-pos-y (estado-no no))))
    (cond
     ((and (null bispo-pos)
           (not (null pos))
           (or (not (equal jogador pos)) (not (equal (muda-jogador jogador) pos))))
      (let* ((board-t (substituir linha bispo-pos-y (estado-no no) jogador))
             (simetrico (simetrico-pos (get-celula linha bispo-pos-y (estado-no no)) board-t)))
        (cond
         ((null simetrico) (create-no (substituir linha bispo-pos-y (estado-no no) jogador) no pos))
         (t (create-no (substituir (car simetrico) (cadr simetrico) board-t 'NIL) no pos)))))
     (t (estado-no no))))
)

;Fun��o para colocar o jogador no board
(defun coloca-jogador-board(y jogador board)
  (cond
   ((or (null y) (null jogador) (null board)) nil)
   ((= jogador -1) (substituir 1 y board -1))
   ((= jogador -2) (substituir (length board) y board -2)))
)

;******************* OPERADORES *******************

;Fun��o que, ao receber um n�mero, neste caso, entre 11 e 88, separa-os para dentro de uma lista
;;(separa-num 33)
(defun separa-num(numero)
  (loop for x across (write-to-string numero) collect (digit-char-p x))
)

;Fun��o que recebe uma linha e retorna o maior duplo dessa linha
;;(duplo-maior-linha (get-linha 4 (jogar-board)))
(defun duplo-maior-linha(linha &optional (duplo nil))
  (let ((numeros (separa-num (car linha))))
    (cond
     ((null linha) duplo)

     ;Caso o duplo seja nil, a primeira casa da linha n�o seja o bispo e os numeros forem iguais, vai passar o resto da linha
     ((and (null duplo) (not (equal T (car linha))) (equal (car numeros) (cadr numeros))) 
      (duplo-maior-linha (cdr linha) (car linha)))

     ;Caso o duplo n�o seja nil, a cabe�a da linha n�o esteja vazia, o maior duplo n�o seja igual ao bispo, a cabe�a da linha n�o seja igual ao bispo, os valores serem iguais e se o duplo for menor que a cabe�a da linha
     ((and (not (null duplo)) (not (null (car linha))) (not (equal T duplo)) (not (equal T (car linha))) (equal (car numeros) (cadr numeros)) (< duplo (car linha)))
      (duplo-maior-linha (cdr linha) (car linha)))

     (t (duplo-maior-linha (cdr linha) duplo))))
)

;Fun��o que recebe um board e retorna o maior duplo que contem
;;(duplo-maximo (jogar-board))
(defun duplo-maximo(board &optional (duplo nil))
  (let ((maior-linha (duplo-maior-linha (car board))))
    (cond
     ((null board) duplo)

     ;Caso o duplo seja nil, o maior duplo n�o seja nil e n�o seja igual ao bispo
     ((and (null duplo) (not (null maior-linha)) (not (equal T maior-linha)))
      (duplo-maximo (cdr board) maior-linha))

     ;Caso o duplo n�o seja nil, o maior duplo n�o seja nil, n�o seja igual ao bispo, a cabe�a da linha n�o seja o bispo e o duplo seja menor que o maior da linha
     ((and (not (null duplo)) (not (null maior-linha)) (not (equal T duplo)) (not (equal T maior-linha)) (< duplo maior-linha))
      (duplo-maximo (cdr board) maior-linha))

     (t (duplo-maximo (cdr board) duplo))))
)

;Fun��o que retorna o valor da posi��o y do valor simetrico de n numa determina linha, se existir
;;(simetrico-pos-linha 31 (get-linha 1 (jogar-board)))
(defun simetrico-pos-linha(n linha &optional (y 1))
  (let* ((numeros (separa-num n)) (simetrico (separa-num (car linha))))
    (cond
     ((null linha) nil)
     ((equal (get-board-reverse numeros) simetrico) y)
     (t (simetrico-pos-linha n (cdr linha) (1+ y)))))
)

;Fun��o que retorna a posi��o (x y) do numero simetrico de n  num determinado board, caso exista
;;(simetrico-pos 54 (jogar-board))
(defun simetrico-pos(n board &optional (x 1))
  (let ((simetrico (simetrico-pos-linha n (car board))))
    (cond
     ((null board) nil)

     ; Caso o n seja um numero duplo ou seja menor que 11 ou maior que 88, vai buscar o maior duplo por default
     ((or (equal (car (separa-num n)) (cadr (separa-num n))) (< n 11) (> n 88)) (get-valor-pos (duplo-maximo board) board))

     ((not (null simetrico)) (cons x (cons simetrico nil)))
     (t (simetrico-pos n (cdr board) (1+ x)))))
)

;Fun��o que retorna a posicao y do primeiro valor da primeira linha
;;(primeiro-valor-y (jogar-board))
(defun primeiro-valor-y(board &optional (y 1))
  (let ((pos (verifica-pos 1 y board)))
    (cond
     ((or (equal 'NIL pos) (equal 'T pos)) (primeiro-valor-y board (+ y 1)))
     (t y)))
)

;Fun��o que retorna os valores da primeira linha
;;(get-valor-linha (jogar-board))
(defun get-valor-linha(board &optional (linha (get-linha 1 board)))
  (cond
   ((or (null board) (null linha)) nil)
   (t (let* ((valor (car linha)))
     (cond
      ((equal 'NIL valor) (get-valor-linha board (cdr linha)))
      (t (cons valor (get-valor-linha board (cdr linha))))))))
)

;Fun��o que retorna a posicao y dos valores da primeira linha
;;(get-valores-linha (jogar-board))
(defun get-valores-linha(board &optional (linha (get-linha 1 board)))
  (cond
   ((or (null board) (null linha)) nil)
   (t (let* ((valor (car linha))
             (pos (cadr (get-valor-pos valor board))))
     (cond
      ((equal 'NIL valor) (get-valores-linha board (cdr linha)))
      (t (cons pos (get-valores-linha board (cdr linha))))))))
)

;Fun��o que conta a ocorrencia de um determinado elemento
;;(conta-nil '(NIL NIL 54 NIL) 'NIL)
(defun conta-nil(lista element)
  (cond
   ((null lista) 0)
   ((equal (car lista) element) (1+ (conta-nil (cdr lista) element)))
   (t (conta-nil (cdr lista) element)))
)                           

;**** FUN��ES OPERADORES ****

;;(diagonal-1-pos (jogar-board) -1)
(defun diagonal-1-pos(board jogador &optional (bispo-pos (posicao-jogador board jogador)))
  (cond
   ((null bispo-pos) (diagonal-1-pos (coloca-jogador (create-no board nil) jogador) jogador))
   ((or (< (car bispo-pos) 0) (< (cadr bispo-pos) 0) (> (car bispo-pos) 8) (> (cadr bispo-pos) 8) (equal (car bispo-pos) 0) (equal (cadr bispo-pos) 0)) nil)
   (t (cons bispo-pos (diagonal-1-pos (cdr board) jogador (list (- (car bispo-pos) 1) (+ (cadr bispo-pos) 1))))))
)

;;(diagonal-2-pos (jogar-board))
(defun diagonal-2-pos(board jogador &optional (bispo-pos (posicao-jogador board jogador)))
  (cond
   ((null bispo-pos) (diagonal-2-pos (coloca-jogador (create-no board nil) jogador) jogador))
   ((or (< (car bispo-pos) 0) (< (cadr bispo-pos) 0) (> (car bispo-pos) 8) (> (cadr bispo-pos) 8) (equal (car bispo-pos) 0) (equal (cadr bispo-pos) 0))  nil)
   (t (cons bispo-pos (diagonal-2-pos (cdr board) jogador (list (- (car bispo-pos) 1) (- (cadr bispo-pos) 1))))))
)

;;(diagonal-3-pos (jogar-board))
(defun diagonal-3-pos(board jogador &optional (bispo-pos (posicao-jogador board jogador)))
  (cond
   ((null bispo-pos) (diagonal-3-pos (coloca-jogador (create-no board nil) jogador) jogador))
   ((or (< (car bispo-pos) 0) (< (cadr bispo-pos) 0) (> (car bispo-pos) 8) (> (cadr bispo-pos) 8) (equal (car bispo-pos) 0) (equal (cadr bispo-pos) 0))  nil)
   (t (cons bispo-pos (diagonal-3-pos (cdr board) jogador (list (+ (car bispo-pos) 1) (- (cadr bispo-pos) 1))))))
)

;;(diagonal-4-pos (jogar-board))
(defun diagonal-4-pos(board jogador &optional (bispo-pos (posicao-jogador board jogador)))
  (cond
   ((null bispo-pos) (diagonal-4-pos (coloca-jogador (create-no board nil) jogador) jogador))
   ((or (< (car bispo-pos) 0) (< (cadr bispo-pos) 0) (> (car bispo-pos) 8) (> (cadr bispo-pos) 8) (equal (car bispo-pos) 0) (equal (cadr bispo-pos) 0))  nil)
   (t (cons bispo-pos (diagonal-4-pos (cdr board) jogador (list (+ (car bispo-pos) 1) (+ (cadr bispo-pos) 1))))))
)

;Fun��o que retorna os valores das posi��es recebidas
;;(get-valor-posicao (diagonal-1-pos (jogar-board)) (jogar-board)) 
(defun get-valor-posicao(lista board)
  (cond
   ((null lista) nil)
   ((null board) nil)
   (t (let* ((posicao (car lista))
          (valor (get-celula (car posicao) (cadr posicao) board)))
        (cond
         ((equal 'T valor) (get-valor-posicao (remove-item 0 lista) board))
         (t (cons valor (get-valor-posicao (cdr lista) board)))))))
)

;Remover um item de uma lista
;;(remove-item 0 '(T 1 2 3))
(defun remove-item (item lista)
  (if (> item 0)
      (cons (car lista) (remove-item (1- item) (cdr lista)))
    (cdr lista))
)

;Remove todos os NIL da lista
;;(remove-nil '(NIL NIL NIL NIL NIL NIL 11 NIL 77))
(defun remove-nil (lista)
  (cond
   ((null lista) NIL)
   ((null (car lista)) (remove-nil (cdr lista)))
   ((< (car lista) 0) (remove-nil (cdr lista)))
   ((atom (car lista)) (cons (car lista) (remove-nil (cdr lista))))
   (t (cons (remove-nil (car lista)) (remove-nil (cdr lista)))))
)


;Devolve o valor de um determinado indice
;;(get-item-index 1 '(1 2 3 4))
(defun get-item-index(n lista)
  (if (zerop n)
      (car lista)
    (get-item-index (1- n) (cdr lista)))
)                           

;Fun��o que coloca o bispo na nova casa jogada
;;(print-board (jogar-bispo (posicoes-jogadas-possiveis (jogadas-possiveis (jogar-board)) (jogar-board)) (jogar-board)))
;(jogar-bispo lista (coloca-bispo board) jogador)
(defun jogada(lista board jogador)
  (cond
   ((and (null lista) (null board)) nil)
   (t (let* ((posicao lista)
         (bispo-pos (posicao-jogador board jogador))
         (pos-new (verifica-pos (car posicao) (cadr posicao) board)))         
     (cond
      ((null posicao) nil)
      ((or (equal jogador pos-new) (null pos-new) (equal (muda-jogador jogador) pos-new)) nil)
      (t (let ((valor (get-celula (car posicao) (cadr posicao) board)))
        (cond
         ((null valor) nil)
         (t (let* ((board-t (substituir (car bispo-pos) (cadr bispo-pos) board 'NIL))
                (board-t-1 (substituir (car posicao) (cadr posicao) board-t jogador))
                (simetrico (simetrico-pos valor board-t-1)))
           (cond
            ((null simetrico) board-t-1)
            (t (substituir (car simetrico) (cadr simetrico) board-t-1 'NIL))))))))))))
)

;;(verifica-jogada (jogar-board-teste) -1)
(defun verifica-jogada(board &optional (jogador -1) (pos (posicoes-jogadas-possiveis (jogadas-possiveis board jogador) board)))
  (cond
   ((null jogador) nil)
   (t (let ((pos-outro (posicoes-jogadas-possiveis (jogadas-possiveis board (muda-jogador jogador)) board)))
     (cond
      ((null pos-outro) nil)
      (t (append pos pos-outro))))))
)

;(defun jogadas-sem-perigo(lista)
  
   

;Fun��o que retorna todas as posicoes das diagonais
;;(jogadas-possiveis (coloca-jogador-board 4 -1 (jogar-board)) -1)
(defun jogadas-possiveis-total(board jogador)
  (cond
   ((null board) nil)
   (t (let ((op-1 (remove-item 0 (diagonal-1-pos board jogador)))
            (op-2 (remove-item 0 (diagonal-2-pos board jogador)))
            (op-3 (remove-item 0 (diagonal-3-pos board jogador)))
            (op-4 (remove-item 0 (diagonal-4-pos board jogador))))
        (append op-1 op-2 op-3 op-4)))) 
)

;Jogadas possiveis que pode ser realizadas pelo jogador
;;(jogadas-possiveis (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board)) -1)
(defun jogadas-possiveis(board jogador)
  (cond
   ((null board) nil)
   (t (let ((pos (posicao-jogador board jogador)))
      (cond
       ((null pos) 
        (let* ((linha (if(= jogador -1) 1 (length board)))
              (melhor (melhor-valor (get-linha linha board)))
              (bispo-pos-y (get-coluna-valor melhor (get-linha linha board))))
          (cond
           ((or (not (null linha)) (not (null melhor)) (not (null bispo-pos-y))) (jogadas-possiveis (coloca-jogador-board bispo-pos-y jogador board) jogador)))))
       (t (let* ((valores (get-valor-posicao (jogadas-possiveis-total board jogador) board))
              (val (remove-nil valores)))
         (cond
          ((null val) nil)
          (val))))))))
)

;Fun��o que retorna todas as posicoes possiveis para o jogador jogar
;;(posicoes-jogadas-possiveis (jogadas-possiveis (coloca-jogador-board 4 -1 (jogar-board)) -2) (coloca-jogador-board 4 -1 (jogar-board)))
(defun posicoes-jogadas-possiveis(lista board)
  (cond
   ((null lista) nil)
   (t (cons (get-valor-pos (car lista) board) (posicoes-jogadas-possiveis (cdr lista) board))))
)         

;******************* SUCESSORES *******************

;Fun��o que retorna o valor da casa que vai corresponder � proxima jogada
;;(pos-valor (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board)) (jogada '(2 3) (coloca-jogador-board 4 -1 (jogar-board)) -1) -1)
(defun pos-valor(no sucessor jogador)
  (let ((bispo-pos (posicao-jogador sucessor jogador))) ;Posicao atual do bispo do jogador
    (cond
     ((null bispo-pos) nil)

     ;Se o jogador for o -1, retorna o valor da casa
     ((= jogador -1) 
      (verifica-pos (car bispo-pos) (cadr bispo-pos) (estado-no no)))

     ;Se for o jogador -2, retorna o valor da casa mas negativo, devido ao algoritmo negamax, pois � necess�rio o maior valor negativo
     (t (* -1 (verifica-pos (car bispo-pos) (cadr bispo-pos) (estado-no no))))))
)

;Fun��o que cria um novo sucessor a partir de um n�
;;(new-sucessor (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board)) 'jogada '(2 3) -1)
(defun new-sucessor(no jogada posicao jogador)
  (let* ((sucessor (create-no (funcall jogada posicao (estado-no no) jogador) no)) 
         (valor (pos-valor no (estado-no sucessor) jogador)))
    (cond
     ((or (null no) (null sucessor) (null valor)) nil)
     (t (create-no (estado-no sucessor) no valor))))
)

;Fun��o que retorna os sucessores de um no
;;(sucessores (create-no (coloca-jogador-board 4 -1 (jogar-board)) (jogar-board)))
(defun sucessores(no &optional (jogador -1) (lista (posicoes-jogadas-possiveis (jogadas-possiveis (car no) jogador) (car no))))
  (cond
   ((or (null no) (null lista)) nil)
   (t (let ((posicao (car lista)))
        (cond
         ((null (posicao-jogador (estado-no no) jogador)) (list (coloca-jogador no jogador)))
         (t (remover-se #'(lambda (x) (null x)) (cons (new-sucessor no 'jogada posicao jogador) (sucessores no jogador (cdr lista)))))))))
)

;******************* BOARD *******************

;Fun��o que recebe um n�mero positivon e cria uma lista com todos os n� entre 11 e o n�mero passado como argumento
;;(lista-numeros)
(defun lista-numeros(&optional (n 88))
  (cond
   ((< n 11) nil)
   ((> n 88) nil)
   (t (cons n (lista-numeros (- n 1))))
   )
)

;Fun��o que recebe uma lista e ir� mudar aleatoriamente os seus n�meros
;;(baralhar (lista-numeros))
(defun baralhar(l)
  (cond
   ((null l) nil)
   (t (let ((n (nth (random (length l)) l)))
        (cons n (baralhar (remover-se #'(lambda (num) (= num n)) l)))
        )))
)

;Fun��o que remove da lista, o n�mero que for escolhido
;;(remover-se #'(lambda (num) (= num 5)) '(1 3 5 2 4 5 6 5))
(defun remover-se(lamb l)
  (cond
   ((null l) nil)
   ((funcall lamb (car l)) (remover-se lamb (cdr l)))
   (t (cons (car l) (remover-se lamb (cdr l))))
   )
)

;Fun��o que remove os numeros que contenham o valor 0 e 9
;;(baralhar-0-9 (baralhar (lista-numeros)))
(defun baralhar-0-9(lista)
  (cond
   ((null lista) nil)
    (t (let* ((valor (car lista))
          (separa (separa-num valor)))
      (cond
       ((null separa) nil)
       ((or (equal 0 (cadr separa)) (equal 9 (cadr separa))) (baralhar-0-9 (remover-se #'(lambda (n) (= n valor)) lista)))
       (t (cons valor (baralhar-0-9 (cdr lista))))))))
)
       
;Fun��o que recebe uma lista e cria sublistas de n elementos
;;(board-random)
(defun board-random (&optional (l (baralhar-0-9 (baralhar (lista-numeros)))) (n 8))
  (cond
   ((null l) nil)
   (t (cons (subseq l 0 n) (board-random (subseq l n) n)))
   )
)

;Board
(defun jogar-board()
'((37 62 55 31 73 58 51 47) 
  (35 44 38 12 41 83 74 68) 
  (36 33 24 27 18 75 88 61)
  (54 43 32 34 81 78 87 77) 
  (56 13 15 86 42 71 21 46) 
  (85 28 45 11 64 14 63 22) 
  (17 57 16 66 82 47 72 48) 
  (53 67 23 76 25 84 65 26))
)


;Board para testes
(defun jogar-board-teste()
'((37 62 55 31 73 58 51 47) 
  (35 44 38 12 41 83 74 68) 
  (36 33 -1 27 18 75 88 61)
  (54 43 32 34 81 78 87 77) 
  (56 13 15 86 42 71 21 46) 
  (85 28 45 11 64 14 63 22) 
  (-2 57 16 66 82 47 72 48) 
  (53 67 23 76 25 84 65 26))
)

;******************* PRINT BOARDS *******************

;Mostra um tabuleiro formatado
(defun print-board(board &optional (stream t))
   (not (null (mapcar #'(lambda(l) (format stream "~%~t~t ~a" l)) board)))
)

;Imprime uma lista de boards
(defun print-boards (boards &optional (stream t))
  (not (null (mapcar #'(lambda(board) (format stream "~%~t~t ~a" (print-board board))) boards)))
)