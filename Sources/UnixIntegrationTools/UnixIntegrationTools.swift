//
//  UnixIntegrationTools.swift
//
//  Unix Integration Tools containsts a suite of methods that allow swift code to connect to the Unix environment. Two classes are provided. the first, "UnixSession" contains a single method that runs a Unix command as if that command were run at a Unix command line. The result of the command is captured as a variable and returned by the method.
//
// The UnixFile class contains methods that simplify access to a file through the Unix system. It provides methods to create/write, read or delete a file as well as determine the date the file was last modified.
//
// The UnixFile class is original work. The "shell" method was copied from https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild
// (c) 2022. All Rights Reserved. One Way Path Group Limited.
// First version created by Alex Young on 1/15/22.


import Foundation


/// Contains a single method that provides access to the unix shell enviroment and allows the code to call any Unix executable file.
public final class UnixSession {
    
    public init() {
        
    }
    
    /// Provides access to the unix shell enviroment and allows the code to call any Unix executable file.
    /// - Parameter command: A string containing the unix command that would hae been entered into Unix shell command line including any desired parameters for the Unix command.
    /// - Returns: A string containing output from the unix command as it would appear if the command had been entered at the Unix command line. Note: depending on the intended use for the command result, it may be necessary to remove the last character because some commands result in output that ends with a carriage return.
    public func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        // launch the Unix command
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        // Get the result of the Unix command
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}

/// This class contains properties and methods that use the shell() method in order to simplify access to a file through the Unix file system. The Unix file to be accessed is represented by the current object model defined by UnixFile.
public final class UnixFile {
    
    var directory: String // the directory where the file exists or will be saved
    var name : String // the file name
    var path : String // the full unix file path including directory and file name
    
    init(at directory: String, named fileName: String) {
        self.directory = directory
        self.name = fileName
        self.path = self.directory + self.name
    }
    
    /// Adds text to the file represented by the current object. If the file already exists, write() will append to it. If the file does not exist, write() will create the file only if the directory already exists. If the directory does not exist it needs to be created first.
    /// - Parameter text: A text string to be written to the file
    public func write(_ text:String) {
        let unix = UnixSession()
        print("writing to file at \(self.path)")
        _ = unix.shell("printf '\(text)' >> \(self.path)") // use the Unix command "printf" to write to the file
    }
    
    /// Reads the contents of the file represented by the current object.
    /// - Returns: Returns a String containing the contents of the file represented by the current object.
    public func read() -> String {
        let unix = UnixSession()
        print("reading file at \(self.path)")
        let fileContents = unix.shell("cat \(self.path)") // use the Unix command "cat" to read the file
        return fileContents
    }
    
    /// Deletes the file represented by the current object.
    public func delete() {
        let unix = UnixSession()
        print("deleting file at \(self.path)")
        _ = unix.shell("rm \(self.path)") // use the Unix command "rm" to delete the fil
    }
    
    /// Determines the date a file was created
    /// - Returns: A Date() object containing the date/time the file represented by the current object was the last modified. If the date cannot be determined, dateCreated returns nil.
    public func dateModified() -> Date? {
        let unix = UnixSession()
        var dateStr = unix.shell("date -r \(self.path) +%s") // use the Unix command "date" to check the last date/time the file was modified. The file path is passed as a parameter to "date" and the %s switch is used to format the result as seconds since 1970.
        
        dateStr = String(dateStr.dropLast())
        guard let dateInt = Int(dateStr) else { //return nill if nothing was returned to the date command. This could happen if there is no file at the given path.
            print ("the date of the file could not be determined")
            return nil
        }
        // convert the date to the swift Date type.
        let epochTime = TimeInterval(dateInt)
        let date = Date(timeIntervalSince1970: epochTime)
        return date
    }
    
    
    
}
