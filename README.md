LakeSISE
========

For this project to work, You need instruct Your maven to install local *.jar as one of the pom's dependencies.
Because project required CLISPJNI.jar, You need to install it manually. To do so go to **clisp/lib/README.md**;

To launch the program
You need to include -Djava.library.path=clisp/ (or the path which points to CLISPJNI.dll na libCLISPJNI.jnilib) to Your launcher cfg