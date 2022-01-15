//
//  File.swift
//  
//
//  Created by Alex Young on 1/15/22.
//

import Foundation


public final class UnixSession {

    public init() {
        
    }
    
    public func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}

public final class UnixFile {
    
    
    var directory: String
    var name : String
    var path : String
    
    init(at directory: String, named fileName: String) {
        
        self.directory = directory
        self.name = fileName
        self.path = self.directory + self.name
        
        
    }

    
    
    /// Adds text to the file. If the file already exists, write() will append to it. If the file does not exist, write() will create it as long as the directory already exists. If the directory does not exist it needs to be created first.
    /// - Parameter text: A text string to be written to the file
    public func write(_ text:String) {
        let unix = UnixSession()
        print("writing to file at \(self.path)")
        _ = unix.shell("printf '\(text)' >> \(self.path)")
    }
    
    /// Reads the contents of a file.
    /// - Returns: Returns a String containing the contents of a file
    public func read() -> String {
        let unix = UnixSession()
        print("reading file at \(self.path)")
        let fileContents = unix.shell("cat \(self.path)")
        return fileContents
    }
    
    /// Deletes the file.
    public func delete() {
        let unix = UnixSession()
        print("deleting file at \(self.path)")
        _ = unix.shell("rm \(self.path)")
    }
    
    /// Determines the date a file was created
    /// - Returns: A Date() object containing the date the file was created. If the date cannot be determined, returns nil
    public func dateCreated() -> Date? {
        let unix = UnixSession()
        var dateStr = unix.shell("date -r \(self.path) +%s")
       
        dateStr = String(dateStr.dropLast())
        guard let dateInt = Int(dateStr) else {
            print ("the date of the file could not be determined")
            return nil
        }
        let epochTime = TimeInterval(dateInt)
        let date = Date(timeIntervalSince1970: epochTime)   // "Apr 16, 2015, 2:40 AM"
        return date
    }
    
    
    
}
