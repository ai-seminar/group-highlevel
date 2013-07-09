(defsystem seminar-high-level-homework
  :author "Jannik Buckelo, Steffen Giese, Paul Meißner, Arne Stefes"
  :license "BSD"
  :description "A roslisp package called 'seminar-high-level-homework'"

  :depends-on (roslisp
               turtlesim-msg)
  :components
  ((:module "src"
    :components
    ((:file "package")
     (:file "seminar-high-level-homework" :depends-on ("package"))))))
