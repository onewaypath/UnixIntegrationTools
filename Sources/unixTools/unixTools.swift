//
//  unixTools.swift
//  App
//
//  Created by Alex Young on 3/18/20.
//

/* This is a collection of tools that allow developers to run Unix commands from within a swift server-side application. The first function "runUnix" runs a Unix command and returns the result as a variable. The function "runUnixToFile" also runs a Unix command but it sends the output to a file instead of returning it as a variable. The last function is a test function that demonstrates how to use the tools to perform various common Unix functions. */

import Foundation

public struct unixTools {
    
    public init() {}
    
    public func runUnix(_ command: String, commandPath: String = "/bin/", arguments: [String] = []) -> String {
        
        // Create a process (was NSTask on swift pre 3.0)
        let task = Process()
        let path = commandPath + command
        
        // Set the task parameters
        task.launchPath = path
        task.arguments = arguments
        
        // Create a Pipe and make the task
        // put all the output there
        let pipe = Pipe()
        task.standardOutput = pipe
        
        // Launch the task
        task.launch()
        
        // Get the data
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        return (output!)
        
    }

    public func runUnixToFile(_ command: String, arguments: [String] = [], filePath: String) {
        
        // Create a process (was NSTask on swift pre 3.0)
        let task = Process()
        let path = "/bin/\(command)"
        
        // Set the task parameters
        task.launchPath = path
        task.arguments = arguments
        
        // Create a Pipe and make the task
        // put all the output there
        //let pipe = Pipe()
        //task.standardOutput = pipe
        
        let fileOutPut = FileHandle(forWritingAtPath: filePath)
        task.standardOutput = fileOutPut
        
        // Launch the task
        task.launch()
        
        
    }

    public func test() {

        let homeDirectory = "/Users/alexyoung/"
        let workingDirectory = "\(homeDirectory)swift/test/"
        let fileName = "\(workingDirectory)foo.txt"
        var unixCommand = "pwd"

        // Run a standard unix command

        print("Running the standard unix command, \(unixCommand)...\r")
        var commandResult = runUnix(unixCommand)
        print("The runtime directory is:\r \(commandResult)")

        unixCommand = "ls"
        print("Running the standard unix command, \(unixCommand)...\r")
        commandResult = runUnix(unixCommand, arguments: [homeDirectory])
        print ("The contents of your home directory is:\r \(commandResult)")

        // Create a file
        print("Creating a new file at path, \(fileName)...")
        commandResult = runUnix("touch", commandPath: "/usr/bin/", arguments: [fileName])
        commandResult = runUnix("ls", arguments: [workingDirectory])
        print("The contents of the directory \(workingDirectory) is:\r \(commandResult)")

        // Move or rename a file

        print("Moving the file \(fileName) to \(fileName).new...\r")
        commandResult = runUnix("mv", arguments: [fileName, "\(fileName).new"])

        commandResult = runUnix("ls", arguments: [workingDirectory])
        print("The contents of the directory \(workingDirectory) is now:\r \(commandResult)")

        print("Moving the file \(fileName).new to \(fileName)...\r")
        commandResult = runUnix("mv", arguments: ["\(fileName).new", fileName])

        commandResult = runUnix("ls", arguments: [workingDirectory])
        print("The contents of the directory \(workingDirectory) is:\r \(commandResult)")

        // Write to a File

        let text = "Hello, World!"
        runUnixToFile("echo", arguments: [text], filePath: fileName)

        // Read from a File
        print("Reading from the file \(fileName)...\r")
        commandResult = runUnix("cat", arguments: [fileName])
        print ("the Contents of the file \(fileName) is:\r \(commandResult)")

        //Delete a File
        print("Deleting the file \(fileName)...\r")
        commandResult = runUnix("rm", arguments:["-rf", fileName])
        commandResult = runUnix("ls", arguments: ["/Users/alexyoung/swift/test/"])
        print("The file has been deleted. The contents of \(workingDirectory) is now:\r \(commandResult)")

    }
}
