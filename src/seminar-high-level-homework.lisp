(defpackage :seminar-high-level-homework
  (:use :cl :roslisp)
  (:export :main))
(in-package :seminar-high-level-homework)

;; NOTE: The *cities* variable holds all cities that are
;; available. They are given as a list which consists of lists of
;; key-value pairs. In our case, the keys `name' and `coordinates' are
;; defined.
(defvar *cities* (list (list (cons 'name "City 1")
                             (cons 'coordinates '(1.0 3.0)))
                       (list (cons 'name "City 2")
                             (cons 'coordinates '(3.0 1.0)))
                       (list (cons 'name "City 3")
                             (cons 'coordinates '(-1.0 0.0)))
                       (list (cons 'name "City 4")
                             (cons 'coordinates '(2.0 2.0)))
                       (list (cons 'name "City 5")
                             (cons 'coordinates '(5.0 0.0)))
                       (list (cons 'name "City 6")
                             (cons 'coordinates '(-4.0 0.0)))
                       (list (cons 'name "City 7")
                             (cons 'coordinates '(5.0 7.0)))
                       (list (cons 'name "City 8")
                             (cons 'coordinates '(-6.0 3.0)))
                       (list (cons 'name "City 9")
                             (cons 'coordinates '(-10.0 -10.0)))
                       (list (cons 'name "City 10")
                             (cons 'coordinates '(2.0 8.0)))))

(defun read-name (city)
  (cdr (assoc 'name city)))


;; TASK: Write a function for reading the coordinates of a given
;; city. The function `read-name' shows how to read the respective
;; name from a given city dataset.

(defun read-coordinates (city)
  (cdr (assoc 'coordinates city)))
  
  
(defvar *last-turtle-pose* nil)
(defvar *subscriber-started* nil)



(defun send-turtle-velocity (linear angular)
  (roslisp:publish (roslisp:advertise "/turtle1/command_velocity"
                                      "turtlesim/Velocity")
                   (roslisp:make-message "turtlesim/Velocity"
                                         linear linear
                                         angular angular)))

(defun turtle-pose-cb (msg)
  (with-fields (x y theta linear_velocity angular_velocity) msg
    (declare (ignore linear_velocity angular_velocity))
    (setf *last-turtle-pose* (list (cons 'x x)
                                   (cons 'y y)
                                   (cons 'theta theta)))))

;; NOTE: Use this function to get the turtle pose and use the inherent
;; components to judge about the current turtle position and
;; orientation.
(defun get-turtle-pose ()
  (unless *subscriber-started*
    (roslisp:subscribe "/turtle1/pose"
                       "turtlesim/Pose"
                       #'turtle-pose-cb)
    (setf *subscriber-started* t))
  (loop when (not *last-turtle-pose*)
          do (sleep 0.1)
        while (not *last-turtle-pose*))
  *last-turtle-pose*)


(defun go-turtle-go (point)
    (SETQ pos (get-turtle-pose))
    (SETQ xdiff (- (nth 0 point) (cdr (assoc 'x pos))))
    (SETQ ydiff (- (nth 1 point) (cdr (assoc 'y pos))))
	
	(SETQ winkel (atan ydiff xdiff))
	
	(if (> xdiff 0) 
		(if (< ydiff 0) 
			(SetQ winkel winkel) 
			(SETQ winkel (- 0 winkel))
		)
			
		(if (< ydiff 0) 
			(SETQ winkel (- PI winkel)) 
			(SETQ winkel (+ PI winkel))
		)
	)
	
	(print winkel)
	
      	(send-turtle-velocity 0 (- winkel (cdr (assoc 'theta pos))))
	(sleep 2)
	(send-turtle-velocity 1 0)
)

(defvar *node-started* nil)

(defun main ()
  (unless *node-started*
    (roslisp:start-ros-node "seminar_highlevel")
    (setf *node-started* t))
  (print "Hello")
  (loop when (= (send-turtle-velocity 10 1) 0)
	do (sleep 0.1)
	while (= (send-turtle-velocity 10 1) 0))
  (print "Bye Bye"))
