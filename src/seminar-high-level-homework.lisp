(defpackage :seminar-high-level-homework
  (:use :cl :roslisp)
  (:export :main))
(in-package :seminar-high-level-homework)



(defvar *node-started* nil)

(defvar *last-turtle-pose* nil)

(defvar *subscriber-started* nil)

(defvar *color-subscriber-started* nil)

(defvar *speed* 0.4)

(defvar *cross-counter* NIL)

(defvar *prev-color* NIL)


;; NOTE: The *cities* variable holds all cities that are
;; available. They are given as a list which consists of lists of
;; key-value pairs. In our case, the keys `name' and `coordinates' are
;; defined.
(defvar *cities* (list (list (cons 'name "Bremen")
                             (cons 'coordinates '(1.0 3.0)))
                       (list (cons 'name "Oldenburg")
                             (cons 'coordinates '(3.0 1.0)))
                       (list (cons 'name "Frankfurt")
                             (cons 'coordinates '(8.0 0.0)))
                       (list (cons 'name "Dresden")
                             (cons 'coordinates '(2.0 2.0)))
                       (list (cons 'name "New York")
                             (cons 'coordinates '(5.0 0.0)))
                       (list (cons 'name "Istanbul")
                             (cons 'coordinates '(2.0 5.0)))
                       (list (cons 'name "Jerusalem")
                             (cons 'coordinates '(5.0 7.0)))
                       (list (cons 'name "Kambodscha")
                             (cons 'coordinates '(6.0 3.0)))
                       (list (cons 'name "Dubai")
                             (cons 'coordinates '(10.0 10.0)))
                       (list (cons 'name "Moskau")
                             (cons 'coordinates '(4.0 8.0)))))




(defun main ()
  (unless *node-started*
    (roslisp:start-ros-node "seminar_highlevel")
    (setf *node-started* t)
    )
  (visit-cities)
  )




;;Getter and Setter

(defun read-name (city)
  (cdr (assoc 'name city)))


(defun read-coordinates (city)
  (cdr (assoc 'coordinates city)))


(defun set-speed (number)
  (SETF *speed* number)
  )






;;					given functions


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




;;						own functions


;;calculates route for going to a given point
;;and moves there with a speed of *speed* units per second
(defun go-turtle-go (point)
  
  (let*
      (	(pos (get-turtle-pose))
			(xdiff (- (nth 0 point) (cdr (assoc 'x pos))))
			(ydiff (- (nth 1 point) (cdr (assoc 'y pos))))
			(winkel (atan (abs ydiff) (abs xdiff)))
			)
    
    ;; the point is to the right of the turtle
    (if (> xdiff 0)							
	(if (> ydiff 0) 
	    (SETQ winkel winkel)             	         	; the point is over the turtle
	  (SETQ winkel (- (* 2 PI) winkel))                     ; the point is under the turtle
	  )
      ;; the point is to the left of the turtle
      (if (> ydiff 0) 
	  (SETQ winkel (- PI winkel))				; the point is over the turtle
	(SETQ winkel (+ PI winkel))				; the point is under the turtle
	)
      )
    
    (SETQ winkel (- winkel (cdr (assoc 'theta pos))))
    
    ;(send-turtle-velocity 0 winkel)   
    (loop while (= (send-turtle-velocity 0 winkel) 0) do (sleep 0.1))    ; turn the turtle
    (sleep 1)
    (loop while (= (send-turtle-velocity *speed* 0) 0) do (sleep 0.1))    ; move the turtle forward
    ) 
  )



;;checks whether the given city was reached
;;returns T if so,
;;returns NIL if not so.
(defun city-reached (city)
  
  (let 
      (	(limit 0.2)
	(coords (read-coordinates city))
	(turtle (get-turtle-pose))
	)
    
    (if	(and
	 
	 (<= (cdr (assoc 'x turtle)) (+ (nth 0 coords) limit) )
	 (>= (cdr (assoc 'x turtle)) (- (nth 0 coords) limit) )
	 
	 (<= (cdr (assoc 'y turtle)) (+ (nth 1 coords) limit) )
	 (>= (cdr (assoc 'y turtle)) (- (nth 1 coords) limit) )
	 )
	;;THEN :: CITY REACHED => TRUE
	T
      ;;ELSE :: CITY NOT REACHED => FALSE
			NIL
			)
    
    )
  )



;;visit all cities.
(defun visit-cities ()
  
  (SETF *cross-counter* -1)              ; -1 because otherwise it would count 1 line cross at the start
  
  (let* 
      (	(x (cdr (assoc 'x (get-turtle-pose))))
	(y (cdr (assoc 'y (get-turtle-pose))))
			(current-city NIL)
			
			;;new City. Used to return to Startpoint.
			(start (list (cons 'name "Start")
				     (cons 'coordinates (list x y)))
			       )
			)
    
    (change-bg-color)                   ; change the background color at the start

    (check-cross)                       ; check if the turtle crosses its line

    ;; processes all cities and let the turtle visit them
    (loop for x from 0 to (- (length *cities*) 1) do
	  (SETQ current-city (nth x *cities*))
	  
	  (loop while (not (city-reached current-city)) do
		(go-turtle-go (read-coordinates current-city))
		(sleep 1)
		)
	  (roslisp:ros-info (seminar high-level) "Reached city ~a" (read-name current-city))
	  (roslisp:ros-info (seminar high-level) "Lines crossed  ~a" *cross-counter*)
	  )
    
    
    ;;all citis reached. Return to Start.
    (loop while (not (city-reached start)) do
	  (go-turtle-go (read-coordinates start))
	  (sleep 1)
	  )
    (roslisp:ros-info (seminar high-level) "Returned to the Startpoint. Mission Complete.")
    
    (change-bg-color)
    )
  
  *cross-counter*
  )



;; checks if the turtle crossed its line
(defun check-cross ()
  
  (unless *color-subscriber-started*
    (roslisp:subscribe "/turtle1/color_sensor"
		       "turtlesim/Color"
		       #'check-cross-cb)
    (setf *color-subscriber-started* t))
  )


;; checks the msg if the line got crossed 
(defun check-cross-cb (msg)
  (with-fields (r g b) msg
	       (if		   
		   (and 		    
		    (= r 179)
		    (= g 184)
		    (= b 255)
		    (not (equal (list r g b) *prev-color*))
		    )
		   (SETF *cross-counter* (+ *cross-counter* 1))
		 ()
		 )
	       (SETF *prev-color* (list r g b))
		)
  )

;; changes the background color of the turtlesi to a random color
(defun change-bg-color ()
  
  (roslisp:set-param "/background_b" (random 256))
  (roslisp:set-param "/background_g" (random 256))
  (roslisp:set-param "/background_r" (random 256))
	
  (roslisp:call-service "/clear" 'std_srvs-srv:empty)
  )
