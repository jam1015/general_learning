(define (cube x) (* x x x))
(define (square x) (* x ))

(define (good-enough? previous-guess guess)
  (< (abs (/ (- guess previous-guess) guess)) 0.00000000001))

(define (crt-iter guess x)
  (if (good-enough? guess (improve guess x))
      guess
      (crt-iter (improve guess x) x)))

(define (improve guess x)
  (/
   (+ (/ x (square guess)) (* 2 guess))
   3)
  )

(define (average x y)
  (/ (+ x y) 2))

(define (crt x)
  (crt-iter 1.0 x))

(crt 9)
