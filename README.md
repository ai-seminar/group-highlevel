group-highlevel
===============

Repository for the high-level plan group homework

To install the correct packages for using Emacs and Lisp (SLIME, Swank), see the seminar slides from 2013/05/23 (StudIP).

Basic usage for roslisp: http://www.ros.org/wiki/roslisp/Tutorials/BasicUsage

For tasks, see the source files.


After checking out the source code and installing the mentioned packages, restart your terminal and run the repl:

```
$ rosrun roslisp_repl repl
```

* Press `,`
* Enter `ros-load-system` and press return
* Enter `group_highlevel` and press return
* Enter `seminar-high-level-homework` and press return
* Press `,`
* Enter `!p` and press return
* Enter `SEMINAR-HIGH-LEVEL-HOMEWORK` and press return

You are now in the package for the homework, with all components loaded.
On a new terminal, enter

```
$ roscore
```

This starts the ROS master node. On another terminal, start

```
$ rosrun turtlesim turtlesim_node
```

This starts the turtle simulation node and visualization.

On the repl, enter

```
> (roslisp:start-ros-node "seminar_highlevel")
```

This connects the repl to the ROS master and allows you to communicate with the turtle.

Happy hacking.