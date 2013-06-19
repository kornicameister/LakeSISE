LakeSISE
========

For this project to work, You need instruct Your maven to install local *.jar as one of the pom's dependencies.
Because project required CLISPJNI.jar, You need to install it manually. To do so go to **clisp/README.md**;

Preconditions:
* Ensure that You've installed CLISPJNI.jar in Your local Maven Repository
* Program's Launcher requires three variables set:
** VM options:
*** -Djava.library.path=dll/
** PROGRAM ARGS (absolute paths):
*** [0] path to lake.properties
*** [1] path to ui.properties

To launch the program
You need to include -Djava.library.path=dll/ (or the path which points to CLISPJNI.dll na libCLISPJNI.jnilib) to Your launcher cfg