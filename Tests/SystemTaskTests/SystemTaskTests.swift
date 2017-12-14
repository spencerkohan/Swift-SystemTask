import XCTest
@testable import SystemTask

class SystemTaskTests: XCTestCase {
    func testExample() {
        
        print(SystemTask.execSync("time ls -a .."))
        
        let task = SystemTask(command: "time ls -a ..")
        
        _ = task.events.output.on { string in
            print(string)
        }
        
        let exp = expectation(description: "")
        
        _ = task.events.finish.on {
            print("DONE")
            exp.fulfill()
        }
        
        task.start()
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
