# Unix Integration Tools

Unix Integration Tools containsts a suite of methods that allow swift code to connect to the Unix environment. Two classes are provided. the first, "UnixSession" contains a single method that runs a Unix command as if that command were run at a Unix command line. The result of the command is captured as a variable and returned by the method.

The UnixFile class contains methods that simplify access to a file through the Unix system. It provides methods to create/write, read or delete a file as well as determine the date the file was last modified.

