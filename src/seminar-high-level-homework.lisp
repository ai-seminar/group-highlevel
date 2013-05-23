(in-package :seminar-high-level-homework)

;; The *cities* variable holds all cities that are available. They are
;; given as a list which consists of lists of key-value pairs. In our
;; case, the keys `name' and `coordinates' are defined.
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
                             (cons 'coordinates '(1.0 1.0)))
                       (list (cons 'name "City 8")
                             (cons 'coordinates '(1.0 1.0)))
                       (list (cons 'name "City 9")
                             (cons 'coordinates '(1.0 1.0)))
                       (list (cons 'name "City 10")
                             (cons 'coordinates '(1.0 1.0)))))

(defun read-name (city)
  (cdr (assoc 'name city)))

;; TASK: Write a function for reading the coordinates of a given
;; city. The function `read-name' shows how to read the respective
;; name from a given city dataset.

(defun read-coordinates (city)
  (declare (ignore city)))

(defun send-turtle-velocity (linear angular)
  (roslisp:publish (roslisp:advertise "/turtle1/command_velocity"
                                      "turtlesim/Velocity")
                   (roslisp:make-message "turtlesim/Velocity"
                                         linear linear
                                         angular angular)))
