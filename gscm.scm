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
; Usage: scm -f gscm.scm [golf scheme program source] # runs from argument text
;        scm -f gscm.scm FILE [golf scheme script file] # runs from file
;
; Golf Scheme Language Specification:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A mapping of terms to replace with terms they should be replaced with
(define keys (list #\= #\~ #\+ #\- #\* #\/ #\&  #\| #\!  #\A      #\B     #\C   #\D    #\E      #\F   #\I #\J    #\L     #\N   #\O      #\S  #\'))
(define vals (list '= ''() '+  '-  '*  '/  'and 'or 'not 'append 'begin 'cons 'define 'else    'car  'if 'cond   'lambda 'null? 'display 'cdr 'quote))

; Add variable char => symbol to keys
(define keys (append keys (list #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z)))
(define vals (append vals (list 'a  'b  'c  'd  'e  'f  'g  'h  'i  'j  'k  'l  'm  'n  'o  'p  'q  'r  's  't  'u  'v  'w  'x  'y  'z)))

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
  (lambda ()
    (if (= k (- (string-length str) 1))
      '()
      (begin
        (set! k (+ k 1))
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
      (parse-int (buf) (+ (* 10 sofar) (lookup start numerals numbers)) buf)
      sofar
    )
  )
  (define (parse-str buf)
    (define cur (buf))
    (if (or (null? cur) (eq? cur #\"))
      ""
      (string-append (make-string 1 cur) (parse-str buf))
    )
  )
  (cond
    ((contains? start numerals) (parse-int start 0 buf))
    ((eq? start #\\) (buf))
    ((eq? start #\') (list (list 'quote (list (parse buf)))))
    ((eq? start #\") (parse-str buf))
    (else start)
  )
)

; Replaces all occurrences of items in keys with their associated values
(define (replace buf)
  (define (replace-helper k)
    (define cur (buf))
    (cond
      ((or (null? cur) (eq? cur #\) )) '())
      ((eq? cur #\( ) (cons (replace-helper buf) (replace-helper buf)))
      ((contains? cur keys) (cons (lookup cur keys vals) (replace-helper buf)))
      (else (cons (parse cur buf) (replace-helper buf)))
    )
  )
  (replace-helper 0)
)

; computes the length of a list
(define (len l)
  (if (null? l)
    0
    (+ 1 (len (cdr l)))
  )
)
