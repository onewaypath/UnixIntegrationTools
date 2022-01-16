import XCTest
import class Foundation.Bundle
import UnixIntegrationTools

final class UnixIntegrationToolTests: XCTestCase {
    
    func testWriteRead() {
        let file = UnixFile(at: "", named: "text.txt")
        file.write("Hello, World!")
        let fileContents = file.read()
        XCTAssertEqual(fileContents, "Hello, World!")
        file.delete()
    }
    
    func testDateModified() {
        let file = UnixFile(at: "", named: "text.txt")
        file.write("Hello, World!")
        if let fileDate = file.dateModified() {
            
            let now = Date()
            
            // confirm year is correct
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let nowYear = yearFormatter.string(from: now)
            let fileYear = yearFormatter.string(from: fileDate)
            XCTAssertEqual(nowYear, fileYear)
            
            // confirm month is correct
            let calendar = Calendar.current
            let nowComponents = calendar.dateComponents([.month], from: now)
            let nowMonth = nowComponents.month
            let fileComponents = calendar.dateComponents([.month], from: fileDate)
            let fileMonth = fileComponents.month
            XCTAssertEqual(nowMonth, fileMonth)
            
            // confirm day is correct
            let nowComponents2 = calendar.dateComponents([.day], from: now)
            let nowDay = nowComponents2.day
            let fileComponents2 = calendar.dateComponents([.day], from: fileDate)
            let fileDay = fileComponents2.day
            XCTAssertEqual(nowDay, fileDay)
        }
        
        file.delete()
    }
    
    func testDelete() {
        let file = UnixFile(at: "", named: "text.txt")
        file.write("Hello, World!")
        file.delete()
        XCTAssertEqual(file.dateModified(), nil)
    }
    
    // ensures that a file can be created at a subdirectory
    func testMKdir() {
        
        let unix = UnixSession()
        _ = unix.shell("mkdir test")
        let file = UnixFile(at: "test", named: "text.txt")
        file.write("Hello, World!")
        let fileContents = file.read()
        XCTAssertEqual(fileContents, "Hello, World!")
        file.delete()
        _ = unix.shell("rmdir test")
        
    }
    
}
