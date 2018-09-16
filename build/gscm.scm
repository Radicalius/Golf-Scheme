;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   ____ ____   ____ __  __
;  / ___/ ___| / ___|  \/  |
; | |  _\___ \| |   | |\/| |
; | |_| |___) | |___| |  | |
;  \____|____/ \____|_|  |_|
;
; The Official Golf Scheme Transpiler Written in Scheme
; Author: Zachary Cotton
; Contact: mr.zacharycotton@gmail.com
;
; Where the filename of this program is gscm-$ext
; And $scm = "scm -f" ? $ext == scm
; Usage: $scm gscm-$ext [golf scheme program source] # runs from argument text
;        $scm gscm-$ext FILE [golf scheme script file] # runs from file
;
; Github:
; Golf Scheme Language Specification:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A mapping of terms to replace with terms they should be replaced with
(define keys (list #\> #\<  #\#       #\%         #\=      #\~ #\+ #\- #\* #\/ #\&  #\| #\!  #\A      #\B     #\C   #\D    #\E      #\F   #\I #\J    #\L     #\N    #\M   #\O        #\P       #\Q           #\S  #\'))
(define vals (list '>  '<  'number?  'modulo     'equal?  ''() '+  '-  '*  '/  'and 'or 'not 'append 'begin 'cons 'define 'else    'car  'if 'cond   'lambda 'null? 'list  'display  'prime?  'quotient     'cdr 'quote))

; Add variable char => symbol to keys
(define lowercase (list #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z))
(define keys (append keys lowercase))
(define vals (append vals (list 'a  'b  'c  'd  'e  'f  'g  'h  'i  'j  'k  'l  'm  'n  'o  'p  'q  'r  's  't  'u  'v  'w  'x  'y  'z)))

; implementation of primality tester (because scheme has no builtin :( )
(define (prime? n)
  (define (p x f)
    (if (= x f)
      #t
      (if (= (modulo x f) 0)
        #f
        (p x (+ f 1))
      )
    )
  )(p n 2)
)

; Determines if a character needs to be replaced
(define (contains? key keys)
  (define (contains-helper k)
    (cond
      ((null? k) #f)
      ((eq? (car k) key) #t)
      (else (contains-helper (cdr k)))
    )
  )
  (contains-helper keys)
)

; Finds the replacement value associated with a given key
(define (lookup key keys vals)
  (define (lookup-helper k v)
    (cond
      ((null? k) nil)
      ((eq? (car k) key) (car v))
      (else (lookup-helper (cdr k) (cdr v)))
    )
  )
  (lookup-helper keys vals)
)

; Returns an iterator for a string
(define (buffer str)
  (define k -1)
  (lambda (op)
    (if (= op 0)
      (if (= k (- (string-length str) 1))
        '()
        (begin
          (set! k (+ k 1))
          (string-ref str k)
        )
      )
      (if (= k (- (string-length str) 1))
        '()
        (string-ref str k)
      )
    )
  )
)

(define numerals (list #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
(define numbers  (list 0   1   2   3   4   5   6   7   8   9))

; parses numbers, integers, strings, and quotes
(define (parse start buf)
  (define (parse-int start sofar buf)
    (if (contains? start numerals)
      (parse-int (buf 0) (+ (* 10 sofar) (lookup start numerals numbers)) buf)
      sofar
    )
  )
  (define (parse-str buf)
    (define cur (buf 0))
    (if (or (null? cur) (eq? cur #\"))
      ""
      (string-append (make-string 1 cur) (parse-str buf))
    )
  )
  (cond
    ((contains? start numerals) (parse-int start 0 buf))
    ((contains? start keys) (lookup start keys vals))
    ((eq? start #\\) (buf 0))
    ((eq? start #\') (list (list 'quote (list (parse buf)))))
    ((eq? start #\") (parse-str buf))
    ((eq? start #\() (replace buf))
    (else start)
  )
)

; adds implicit keywords back in
(define (implicit program)
  (if (contains? (string-ref program 0) lowercase)
    (set! program (string-append "D(f" program))
    0
  )
  program
)

; a list of all the golf-scheme keywords that may need leading parenthesis
(define need-l-p (list #\# #\= #\+ #\- #\* #\/ #\&  #\| #\! #\> #\< #\%  #\A #\B #\C #\D #\E #\F #\I #\J #\L #\N #\M #\O #\P #\Q #\S))
(define need-b-p (list #\D #\L #\J))

; adds implicit leading parenthesis
(define (add-lead-p str)
  (define ca (string->list str))
  (define (helper c prev)
    (cond
      ((null? c) '())
      ((and (not (contains? (car c) numerals)) (contains? prev numerals)) (cons #\a (helper c #\a)))
      ((and (not (eq? (car c) #\( )) (contains? prev need-b-p)) (cons #\( (helper c #\()))
      ((and (contains? (car c) need-l-p) (not (eq? prev #\( ))) (cons #\( (cons (car c) (helper (cdr c) (car c)))))
      (else (cons (car c) (helper (cdr c) (car c))))
    )
  ) (list->string (helper ca #\k))
)

(define known-len (list #\F #\S #\C #\I #\N #\P #\# #\= #\+ #\- #\* #\/ #\& #\Q  #\| #\! #\> #\<  #\%))
(define length (list     2   2    3 4   2   2   2   3   3   3   3   3   3   3    3   2   3   3    3  ))

; Replaces all occurrences of items in keys with their associated values
(define (replace buf)
  (define (replace-helper k l)
    (let ((cur (buf 0)))
      (define len (if (contains? cur known-len) (lookup cur known-len length) l))
      (cond
        ((or (null? cur) (eq? cur #\) )) '())
        ((= len 1) (list (parse cur buf)))
        ((eq? cur #\( ) (cons (replace-helper buf -1) (replace-helper buf (- len 1))))
        ((eq? cur #\space) (replace-helper buf (- len 1)))
        ((contains? cur keys) (cons (lookup cur keys vals) (replace-helper buf (- len 1))))
        (else (cons (parse cur buf) (replace-helper buf (- len 1))))
      )
    )
  )
  (replace-helper 0 -1)
)

; transpiles golf scheme to normal Scheme
(define (transpile program)
  (car (replace (buffer (add-lead-p (implicit program)))))
)

; computes the length of a list
(define (len l)
  (if (null? l)
    0
    (+ 1 (len (cdr l)))
  )
)

{{version.tail}}
