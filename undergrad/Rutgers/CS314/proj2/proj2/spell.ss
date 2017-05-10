
; *********************************************
; *  314 Principles of Programming Languages  *
; *  Spring 2017                              *
; *  Student Version                          *
; *********************************************

;; contains "ctv", "A", and "reduce" definitions
(load "include.ss")

;; contains simple dictionary definition
(load "test-dictionary.ss")

;; -----------------------------------------------------
;; HELPER FUNCTIONS

;; *** CODE FOR ANY HELPER FUNCTION GOES HERE ***
      ;for each hashfunctionType in hashfunctionlist
      ;  for each word d_word in dictionary
      ;    call hashfunctionType(d_word), and add to conglomerate list.
(define listHasher
  (lambda (hashList dic)
    (cond ((null? hashList) '()) ;returns nothing when no more elements can be hashed.
          (else           
           (append (map (car hashList) dic) (listHasher(cdr hashList) dic) ) ;just yer typical recursive looping, but with appended lists.
           )
    )
  )
)
;;My own definition of member, since on Piazza question @887 seems to stipulate that Scheme's built in 'member' gives unneccessary false-positives.
(define isMemberOf
  (lambda (genericElement genericList)
    (cond ((null? genericList) #f) ;;only occurs if no true flag has been raised.
          ( (not(= genericElement (car genericList))) 
            (isMemberOf genericElement (cdr genericList))
          )
          (else
           #t ;equality found!
           )
    )
  )
)

;;utilises isMemberOf, to essentially do that stuff for every member in wordList.        
(define verifyHash
  (lambda (dictionaryList wordList)
    (cond ((null? wordList) #f)
          (else
           (isMemberOf (car wordList) dictionaryList)
           
          )
    )
  )
)

;;basically does the operations I could've also easily completed in a single line. Used for reduce(), credit goes to @876
(define keyFunc
  (lambda (arg1 arg2)
    (+ (ctv arg1) (* 29 arg2))
  )
)
 

;; -----------------------------------------------------
;; KEY FUNCTION

(define key
  (lambda (w)
     (keyFunc (car w) (reduce keyFunc (cdr w) 5187))
  )
)
;(key '(h e l l o)) ;;DEBUGGING PURPOSES
;; -----------------------------------------------------
;; EXAMPLE KEY VALUES
;;   (key '(h e l l o))       = 106402241991
;;   (key '(m a y))           = 126526810
;;   (key '(t r e e f r o g)) = 2594908189083745

;; -----------------------------------------------------
;; HASH FUNCTION GENERATORS

;; value of parameter "size" should be a prime number
(define gen-hash-division-method
  (lambda (size) ;; range of values: 0..size-1
    (lambda (w) ;;special thanks to Piazza question @764
      (modulo (key w) size)
    )
  )
)

;; value of parameter "size" is not critical
;; Note: hash functions may return integer values in "real"
;;       format, e.g., 17.0 for 17

(define gen-hash-multiplication-method
  (lambda (size) ;; range of values: 0..size-1
    (lambda (w)
      (floor (* (- (* (key w) A) (floor (* (key w) A)) ) size )) ;; FLOOR[size * k*A - FLOOR[k*A]]
    )
  )
)


;; -----------------------------------------------------
;; EXAMPLE HASH FUNCTIONS AND HASH FUNCTION LISTS

(define hash-1 (gen-hash-division-method 70111))
(define hash-2 (gen-hash-division-method 89997))
(define hash-3 (gen-hash-multiplication-method 7224))
(define hash-4 (gen-hash-multiplication-method 900))

(define hashfl-1 (list hash-1 hash-2 hash-3 hash-4))
(define hashfl-2 (list hash-1 hash-3))
(define hashfl-3 (list hash-2 hash-3))

;(hash-3 '(h e l l o)) ;;DEBUGGING
;; -----------------------------------------------------
;; EXAMPLE HASH VALUES
;;   to test your hash function implementation
;;
;;  (hash-1 '(h e l l o))       ==> 35616
;;  (hash-1 '(m a y))           ==> 46566
;;  (hash-1 '(t r e e f r o g)) ==> 48238
;;
;;  (hash-2 '(h e l l o))       ==> 48849
;;  (hash-2 '(m a y))           ==> 81025
;;  (hash-2 '(t r e e f r o g)) ==> 16708
;;
;;  (hash-3 '(h e l l o))       ==> 6331.0
;;  (hash-3 '(m a y))           ==> 2456.0
;;  (hash-3 '(t r e e f r o g)) ==> 1806.0
;;
;;  (hash-4 '(h e l l o))       ==> 788.0
;;  (hash-4 '(m a y))           ==> 306.0
;;  (hash-4 '(t r e e f r o g)) ==> 225.0


;; -----------------------------------------------------
;; SPELL CHECKER GENERATOR

;;1. Given a type of hashfl-#, and a giant dictionary, run all the hash functions listed in arg1 on arg2, and compile a giant list.
;;2. Given a type of hashfl-#, and a word w, utilise all the hash functions listed in arg1 on arg2, and compile.
;;3. Compare the two: if word_list's values are all contained within dictionary_list, return #t. Else, #f.
(define gen-checker 
  (lambda (hashfunctionlist dict) ;;two inputs here: a hashfl-#, and a dictionary.
    (lambda w ;;added another input for the word to be compared. I'm losing 20 points over a f**king set of parenthesis.


      ;for each hashfunctionType in hashfunctionlist
      ;  call hashfunctionType(word), add to word_list.

      ;for each value in word_list
      ;  for each value in conglomerate list
      ;    if(word_list[i] != conglomerate_list[j]
      ;      return #f
      ;return #t (only occurs if no infraction is found).
     (verifyHash (listHasher hashfunctionlist dict) (listHasher hashfunctionlist w))
      
    )
  )
)


;; -----------------------------------------------------
;; EXAMPLE SPELL CHECKERS

(define checker-1 (gen-checker hashfl-1 dictionary))
(define checker-2 (gen-checker hashfl-2 dictionary))
(define checker-3 (gen-checker hashfl-3 dictionary))

;; EXAMPLE APPLICATIONS OF A SPELL CHECKER
;;
;;  (checker-1 '(a r g g g g)) ==> #f
;;  (checker-2 '(h e l l o)) ==> #t
;;  (checker-2 '(a r g g g g)) ==> #t  // false positive

;(checker-2 '(a r g g g g))DEBUGGING PURPOSES
;(checker-3 '(b l e h))DEBUGGING PURPOSES