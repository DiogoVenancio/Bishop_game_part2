;; Carrega os outros ficheiros de c�digo, escreve e l� ficheiros, e trata da intera��o com o utilizador
;; Autor: Diogo Ven�ncio - 160221076
;; Autor: Andr� Gon�alves - 170221015
;; Ano letivo 19/20

;Variaveis globais
(defvar *jogador1* 0) ;Pontos do jogador n�1
(defvar *jogador2* 0) ;Pontos do jogador n�2
(defvar *jogada* nil) ;Board atual

;Mostra o menu inicial
(defun inicial-menu()
  (progn
    (format t "~% -------------------------------------")
    (format t "~%              Jogo do Bispo            ")
    (format t "~%                                       ")
    (format t "~%            1 - Humano vs PC           ")
    (format t "~%              2 - PC vs PC             ")
    (format t "~%                                       ")
    (format t "~%                s - Sair               ")
    (format t "~% -------------------------------------~%~%> "))
)

;Iniciar programa
(defun start()
  (progn
    (inicial-menu)
      (let ((opt (read)))
        (cond
         ((eq opt 's) (format t "At� � pr�xima!"))
         ((or (< opt 1) (> opt 2)) (progn (format t "Insira uma op��o v�lida") (start)))
         ((eq opt '1) (humano-vs-pc))  ;Chamar fun��o humano vs pc
         ((eq opt '2) (pc-vs-pc)))))  ;Chamar fun��o pc vs pc
)    

;******** PC VS PC ********

;Fun��o respons�vel pelo inicio do jogo pc vs pc
(defun pc-vs-pc()
  (let ((time (time-def)) ;Define o tempo limite de processamento
        (board (jogar-board))) ;Definir o board

    (progn

      ;Escreve no ficheiro para iniciar o jogo
      (file-inicio) 

      ;Escreve para o ficheiro o estado inicial do board
      (file-board-inicio board)
      
      ;Chama a fun��o para o pc executar a jogada como jogador -1
      (jogar-pc board time -1) 

      ;Chama a fun��o para o pc executar a jogada como jogador -2 como o board atualizado
      (jogar-pc *jogada* time -2) 

      ;Chama a fun��o auxiliar
      (pc-vs-pc-aux time))) 
)

;Fun��o respons�vel pela gest�o das jogadas
(defun pc-vs-pc-aux(time)
  (let* ((jogada-1 (jogar-pc *jogada* time -1)) ;Atribui a jogada do jogador -1
        (jogada-2 (jogar-pc *jogada* time -2))) ;Atribui a jogada do jogador -2

     (if (and (null jogada-1) (null jogada-2)) (final 'pc-vs-pc) ;Se n�o houver mais jogadas possiveis, o jogo acaba
       (pc-vs-pc-aux time)))
)

;******** HUMANO VS PC ********

;Menu para selecionar o jogador que faz a 1�jogada
(defun definir-jogador()
  (format t "~% --------------------------------------------------")
  (format t "~%  Jogo do Bispo - Escolha quem inicia a 1� jogada  ")
  (format t "~%                                                   ")
  (format t "~%                   1 - Humano                      ")
  (format t "~%                    2 - PC                         ")
  (format t "~%                                                   ")
  (format t "~%                   s - Sair                        ")
  (format t "~% ---------------------------------------------------~%~%> ")
)

;Fun��o para o jogador escolher se quer jogar em 1�lugar ou o pc
(defun first-jogador()
  (progn
    (definir-jogador)
    (let ((opt (read)))
      (cond
       ((eq opt 's) (format t "At� � pr�xima!"))
       ((or (< opt 1) (> opt 2)) (progn (format t "Insira uma op��o v�lida") (first-jogador)))
       ((eq opt '1) 'humano)
       ((eq opt '2) 'pc))))
)

;Menu do tempo limite de processamento
(defun definir-time()
  (format t "~% ---------------------------------------------------------")
  (format t "~%  Jogo do Bispo - Insira o tempo limite de processamento  ")
  (format t "~%                 (Entre 1 a 5 segundos)                   ")
  (format t "~%                                                          ")
  (format t "~%                       s - Sair                           ")
  (format t "~% ---------------------------------------------------------~%~%> ")
)

;Fun��o que define o tempo limite de processamento
(defun time-def()
  (progn
    (definir-time)
    (let ((option (read)))
      (cond
       ((eq option 's) (format t "At� � pr�xima!"))
       ((or (not (numberp option)) (< option 1) (> option 5)) (progn (format t "O tempo deve estar entre 1 a 5 segundos") (time-def)))
       (t (* option 1000))))) ;Milissegundos
)

;Fun��o que l� o valor que vai ser atribuido a y
(defun pos-y()
  (let ((y (read)))
    (cond
     ((or (< y 1) (> y 8)) (progn (format t "Insira uma coluna v�lida v�lida") (pos-y)))
     (y)))
)

;Fun��o respons�vel em colocar um jogador em campo, tendo em aten��o qual dos jogadores est� a jogar
(defun colocar-bispo(board jogador)
  (cond
   ((null (posicao-jogador board jogador)) ;Verifica se realmente o jogador ainda n�o jogou
    (progn
      (if (equal jogador -1) (format t"~%Escolha uma coluna da 1�linha para colocar o bispo - ") ;Se for o jogador -1
        (format t"~%Escolha uma coluna da 8�linha  para colocar o bispo - ")) ;Jogador -2
      (let* ((valor-y (pos-y)) ;Guarda um valor para y
             (board-new (coloca-jogador-board valor-y jogador board))) ;Coloca o jogador no board atrav�s do valor do y
        (cond
         ((null board-new) (progn (format t"~%Op��o invalida") (colocar-bispo board jogador))) ;Se introduziu um valor incorreto para o y
         (t (setq *jogada* board-new))))))) ;Altera o board atual
)

;Fun��o que imprime os valores das casas para o qual o jogador pode efetuar uma jogada
;;(pos-possiveis -1 1 (posicoes-jogadas-possiveis (jogadas-possiveis (coloca-jogador-board 4 -1 (jogar-board)) -1) (coloca-jogador-board 4 -1 (jogar-board))))
(defun pos-possiveis(jogador &optional (i 1) (posicoes (posicoes-jogadas-possiveis (jogadas-possiveis *jogada* jogador) *jogada*)))
  (cond
   ((null posicoes) ;Quando a lista ficar vazia, imprime a parte de baixo o layout
    (progn
      (format t "~%                                        ")
      (format t "~% -------------------------------------~%~%> ")))
   (t (progn
        (if (= i 1)
            (progn
              (format t"~% --------------------------------------------")
              (format t "~% Jogo do Bispo - Escolha a proxima posicao  ")
              (format t "~%                                            ")))
        (let* ((pos (car posicoes)) ;Guarda a primeira posicao da lista de jogadas
               (valor (verifica-pos (car pos) (cadr pos) *jogada*))) ;Guarda o valor da casa que corresponde � posicao
          (cond
           ((null pos) (final 'humano-vs-pc jogador))
           (t (progn (format t"~%         ~a - Posicao com valor ~a                 " i valor) ;Imprime para o ecr�
           (pos-possiveis jogador (1+ i) (cdr posicoes))))))))) ;Chamada recursiva para ir imprimindo os valores
)

;Fun��o respons�vel pela escolha da nova posi��o feita pelo jogador
(defun read-valor(jogador)
  (progn
    (pos-possiveis jogador) ;menu das jogadas
    (let ((opt (read)))
          (cond
           ((not (numberp opt)) (progn (format t "Insira uma op��o v�lida") (read-valor jogador)))
           (t (let ((lista (jogadas-possiveis *jogada* jogador))) ;Guarda a lista de todas as jogadas que o jogador pode efetuar
                (cond
                 ((null lista) (final 'humano-vs-pc)) ;Se n�o houver jogadas possiveis, o jogo acaba
                 ((or (< opt 0) (> opt (length lista))) (progn (format t "Insira uma op��o v�lida") (read-valor jogador)))
                 (t (list (get-valor-pos (nth (1- opt) lista) *jogada*))))))))) ;Retorna a posicao pretendida
)

;Fun��o que efetua uma jogada do pc
(defun jogar-pc(estado tempo jogador)
  (let* ((path (negamax (create-no estado nil) tempo 'sucessores jogador)) ;Caminho para o no solu��o
         (no-new (get-jogada (car path))) ;Verifica se o no tem n� pai, se n tiver retorna o filho
         (estado-new (estado-no no-new)) ;Guarda o estado atual do board
         (stats (cadr path))) ;Guarda as informa��es do no solu��o
    (cond

     ;Se o board atual estiver vazio
     ((null estado-new) nil)

     (t (let ((points (abs (f-no no-new)))) ;Atribui os pontos com o valor absoluto do valor de f do no
          (progn

            ;Altera o estado do board
            (setq *jogada* estado-new)
            
            ;Imprime o board
            (print-board *jogada*) 
           
            (if (= jogador -1) (progn (setq *jogador1* (+ points *jogador1*)) (format t "~%Pontos Jogador 1 (PC): ~d" points))
              (progn (setq *jogador2* (+ points *jogador2*)) (format t "~%Pontos Jogador 2 (PC): ~d" points)))

            (format t"~%N� de Nos: ~d ~%N� Cortes: ~d ~%Tempo Execu��o: ~d~%" (car stats) (cadr stats) (caddr stats)) ;Imprime os stats
            (write-points 'pc jogador points stats) t))))) ;Escreve para o ficheiro
)

;Fun��o que efetua uma jogada do humano
(defun jogar-humano(jogador posicao)
  (cond
   
   ;Se o board atual estiver vazio ou a posicao estiver vazia
   ((or (null *jogada*) (null posicao)) (final 'humano-vs-pc jogador))

   ;Se o jogador n�o tiver jogado ainda, retorna o estado de um no criado com o board atual
   ((null (posicao-jogador *jogada* jogador)) (estado-no (coloca-jogador (create-no *jogada* nil) jogador)))

   (t (let* ((sucessor (new-sucessor (create-no *jogada* nil) 'jogada posicao jogador)) ;Guarda o sucessor do no segundo a posicao jogada
             (points (abs (f-no sucessor)))) ;Guarda o valor absoluto do valor de f do sucessor
        (progn
          (setq *jogada* (estado-no sucessor)) ;Altera o estado do board
          (print-board *jogada*) ;Imprime o board

          (if (= jogador -1) (progn (setq *jogador1* (+ points *jogador1*)) (format t "~%Pontos Jogador 1 (Humano): ~d" points))
            (progn (setq *jogador2* (+ points *jogador2*)) (format t "~%Pontos Jogador 2 (Humano): ~d" points)))

          (write-points 'humano jogador points))))) ;Escreve para o ficheiro
)         

;Fun��o auxiliar do jogo entre o humano e o pc
(defun humano-vs-pc-aux(time jogador)
  (let* ((pc-first (if (= jogador -2) (jogar-pc *jogada* time (muda-jogador jogador)))) ;Se o jogador for o -2, efetua uma jogada do pc (Quando o pc joga primeiro)
         (pos (read-valor jogador)) ;Guarda o valor da posi��o que o jogador escolheu
         (jogada-humano (jogar-humano jogador (car pos))) ;Efetua a jogada do humano segundo a posicao pretendida
         (jogada-pc-second (if (= jogador -1) (jogar-pc *jogada* time (muda-jogador jogador))))) ;Se o jogador for o -1, efetua uma jogada do pc (Quando o pc joga em segundo)
    (cond

     ;Se a jogada do pc como segundo, a jogada feita pelo humano e a jogada pelo pc como primeiro estiverem vazias, acaba o jogo
     ((and (null jogada-pc-second) (null jogada-humano) (null pc-first)) (final 'humano-vs-pc jogador))

     ;Chama a fun��o recursivamente
     (t (humano-vs-pc-aux time jogador))))
)         

;Fun��o que d� inicio ao jogo entre humano vs pc
(defun humano-vs-pc()
  (let* ((jogador-1 (first-jogador)) ;Guarda qual o jogador que come�a 1�
         (time (time-def)) ;Guarda o tempo limite de processamento
         (board (jogar-board)) ;Guarda o board
         (jogador (if (equal jogador-1 'humano) -1 -2))) ;Guarda o jogador

    (progn
      (cond
       ((equal jogador-1 'humano) ;Se o jogador 1 for o humano
        (progn
          
          ;Imprime o board
          (print-board board)

          ;Coloca o bispo do jogador no board
          (colocar-bispo board jogador)

          ;Escreve para o ficheiro o inicio do jogo
          (file-inicio)

          ;Escreve para o ficheiro o estado inicial do board
          (file-board-inicio board)

          ;Efetua a jogada pelo pc
          (jogar-pc *jogada* time (muda-jogador jogador))))

       (t (progn

            ;Escreve para o ficheiro o inicio do jogo
            (file-inicio)
            
            ;Escreve para o ficheiro o estado inicial do board
            (file-board-inicio board)

            ;Efetua a jogada pelo pc
            (jogar-pc board time (muda-jogador jogador))

            ;Coloca o bispo do jogador no board atual
            (colocar-bispo *jogada* jogador))))
      (cond
       ((equal jogador-1 'humano) ;Se o jogador 1 for o humano
        (humano-vs-pc-aux time -1)) ;Chama a fun��o auxiliar com jogador -1
        (t (humano-vs-pc-aux time -2))))) ;Chama a fun��o auxiliar com jogador -1
)

;Mensagem do final do jogo
(defun final(t-jogo &optional jogador)
  (progn
    (format t "~%---------------------------")
    (format t "~%                           ")
    (format t "~%        Fim do Jogo        ")
    (format t "~%                           ")   
    (format t "~%---------------------------")
    (format t "~%Pontos Jogador 1: ~d" *jogador1*) ;Pontos totais do jogador -1
    (format t "~%Pontos Jogador 2: ~d" *jogador2*)) ;Pontos totais do jogador -2
  (with-open-file (ficheiro (stats-file) :direction :output :if-exists :append :if-does-not-exist :create)
    (progn
      (format ficheiro "~%---------------------------------------")
      (format ficheiro "~%                                       ")

      ;Se o tipo de jogo for pc vs pc
      (if (equal t-jogo 'pc-vs-pc) (format ficheiro "~%           PC VS PC           ")
        (format ficheiro "~%           Humano VS PC           "))

      (format ficheiro "~%                                       ")
      (format ficheiro "~%---------------------------------------")

      ;Se o tipo de jogo for humano vs pc
      (if (equal t-jogo 'humano-vs-pc)
          (if (= jogador -1) (format ficheiro "~%1� Jogador: ~s" 'humano)
            (format ficheiro "~%Humano VS PC: ~s" 'pc)))

      (format ficheiro "~%Pontos Jogador 1: ~d" *jogador1*)) ;Pontos totais do jogador -1
    (format ficheiro "~%Pontos Jogador 2: ~d" *jogador2*)) ;Pontos totais do jogador -2
)


;******** STATS ********

;Fun��o que devolve o caminho para o ficheiro
(defun stats-file()
  (make-pathname :host "c" :directory '(:absolute "lisp") :name "log" :type "dat")
)

;Escreve no ficheiro quando � iniciado um jogo
(defun file-inicio()
  (progn
    (with-open-file (ficheiro (stats-file) :direction :output :if-exists :rename-and-delete :if-does-not-exist :create)
      (progn
        (format ficheiro "~%---------------------------------------")
        (format ficheiro "~%                                       ")
        (format ficheiro "~%                Iniciar                ")
        (format ficheiro "~%                                       ")
        (format ficheiro "~%---------------------------------------"))))
)

;Escreve no ficheiro o estado inicial do board que vai ser jogado
(defun file-board-inicio(board)
  (progn
    (with-open-file (ficheiro (stats-file) :direction :output :if-exists :append :if-does-not-exist :create)
      (progn
        (format ficheiro "~%Estado inicial:                        ")
        (format ficheiro "~%                                       ")
        (print-board board ficheiro)
        (format ficheiro "~%                                       ")
        (format ficheiro "~%Jogo:                                  ")
        (format ficheiro "~%                                       ")
        )))
)

;Fun��o que vai escrevendo para o ficheiro cada jogada
(defun write-points(t-jogador jogador points &optional stats)
  (progn
    (with-open-file (ficheiro (stats-file) :direction :output :if-exists :append :if-does-not-exist :create)
      (progn

        ;Imprime o board atual
        (print-board *jogada* ficheiro)

        (format ficheiro "~%                                       ")

        ;Escreve no ficheiro os pontos ganhamos pelo jogador da jogada
        (format ficheiro "~%Pontos feitos pelo Jogador ~d -~s-: ~d" (if (= jogador -1) 1 2) t-jogador points)

        ;Escreve no ficheiro os stats
        (cond
         ((equal t-jogador 'pc) (format ficheiro "~%N� de Nos: ~d ~%N� Cortes: ~d ~%Tempo Execu��o: ~d~%" (car stats) (cadr stats) (caddr stats)))))))
)
         
