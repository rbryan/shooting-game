
(use-modules (allegro system)
             (allegro display)
             (allegro events)
             (allegro keyboard)
	     (allegro mouse)
             (allegro timer)
             (allegro graphics)
             (allegro addons image))

(define timer #f)
(define events #f)
(define running #t)
(define redraw #t)
(define image #f)
(define window #f)

(define x 0)
(define y 0)
(define theta 0)

(al-init)
(al-init-image-addon)
(al-install-keyboard)
(al-install-mouse)

(define (game-loop)
  (set! window (al-create-display 640 480))
  (set! timer (al-create-timer (/ 1 60)))
  (set! events (al-create-event-queue))
  (set! image (al-load-bitmap "player.png"))
  (al-register-event-source events (al-get-timer-event-source timer))
  (al-register-event-source events (al-get-keyboard-event-source))
  (al-register-event-source events (al-get-mouse-event-source))

  (set! running #t)
  (set! redraw #t)
  (al-start-timer timer)
  (while running
    (let* ((event (al-wait-for-event events))
	   (event-type (al-get-event-type event)))
      (cond ((= event-type allegro-event-display-close)
	     (set! running #f))
	    ((= event-type allegro-event-timer)
             (set! redraw #t)
	     (let ((keyboard-state (al-get-keyboard-state)))
		(if (al-key-down? keyboard-state allegro-key-a)
			(set! x (- x 3)))
		(if (al-key-down? keyboard-state allegro-key-d)
			(set! x (+ x 3)))
		(if (al-key-down? keyboard-state allegro-key-s)
			(set! y (+ y 3)))
		(if (al-key-down? keyboard-state allegro-key-w)
			(set! y (- y 3)))))
	    ((= event-type allegro-event-mouse-axes)
	     (let ((mouse-event (al-get-mouse-event event)))
		     (set! x (+ (al-get-mouse-event-x mouse-event) (* 10 (al-get-mouse-event-w mouse-event))))
		     (set! y (+ (al-get-mouse-event-y mouse-event) (* -10 (al-get-mouse-event-z mouse-event))))
		     (set! theta (atan  (* 10 (al-get-mouse-event-z mouse-event))
					(* -10 (al-get-mouse-event-w mouse-event)))))))
	     
      (when (and redraw (al-is-event-queue-empty? events))
        (set! redraw #f)
        (al-clear-to-color 0 0 0)
        (al-draw-rotated-bitmap image 25 25 x y theta)
        (al-flip-display))))
  (al-destroy-bitmap image)
  (al-destroy-event-queue events)
  (al-destroy-timer timer)
  (al-destroy-display window))

(game-loop)
