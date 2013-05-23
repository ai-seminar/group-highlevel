(defsystem seminar-high-level-homework
  :author "Student names"
  :license "BSD"
  :description "A roslisp package called 'seminar-high-level-homework'"

  :depends-on (roslisp
               turtlesim-msg)
  :components
  ((:module "src"
    :components
    ((:file "package")
     (:file "seminar-high-level-homework" :depends-on ("package"))))))
