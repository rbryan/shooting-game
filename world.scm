(define-module (game world)
	       #:use-module (srfi srfi-9)
	       #:use-module (world entities)
	       #:export (
			 make-world
			 world?
			 get-world-updater
			 set-world-updater!
			 get-world-renderer
			 set-world-renderer!
			 get-world-entities
			 set-world-entities!
			 update-entities
			 ))

(define-record-type <world>
		   (make-world updater renderer entities)
		   world?
		   (updater get-world-updater set-world-updater!)
		   (renderer get-world-renderer set-world-renderer!)
		   (entities get-world-entities set-world-entities!))


(define (update-entities world events time dt)
  (let ((entities (get-world-entities world)))
    (for-each
      (lambda (entity)
	((get-entity-updater) entity events time dt))
      entities)))


