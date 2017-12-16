import XCTest
@testable import SystemTask

class SystemTaskTests: XCTestCase {
    func testSync() {
        let output = SystemTask.execSync("echo \"test\"")
        XCTAssertEqual(output, "test\n")
    }
    
    func testAsync() {
        
        var output = ""
        let task = SystemTask(command: "echo \"test\"")
        _ = task.events.output.on { string in
            output += string
        }
        let exp = expectation(description: "")
        _ = task.events.finish.on {
            XCTAssertEqual(output, "test")
            exp.fulfill()
        }
        task.start()
        waitForExpectations(timeout: 1, handler: nil)
        
    }

    static var allTests = [
        ("testSync", testSync),
        ("testAsync", testAsync),
    ]
}
