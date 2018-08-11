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
; Usage: scheme gscm.scm [golf scheme program source] # runs from argument text
;        scheme gscm.scm -f [golf scheme script file] # runs from file
;
; Golf Scheme Language Specification:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A mapping of terms to replace with terms they should be replaced with
(define keys (list '&   '|  '!   'A      'B     'C   'D       'E       'F    'I  'J      'L      'N      'S))
(define vals (list 'and 'or 'not 'append 'begin 'cons 'define 'else    'car  'if 'cond   'lambda 'null?  'cdr))

(define (lookup key)
  (define (lookup-helper k v)
    (cond
      ((null? k) nil)
      ((eq? (car k) key) (car v))
      (else (lookup-helper (cdr k) (cdr v)))
    )
  )
  (lookup-helper keys vals)
)
