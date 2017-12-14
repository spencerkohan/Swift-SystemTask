import Foundation
import EventEmitter

public class SystemTask {
    
    var task : Process?
    let arguments : [String]
    
    public struct Events {
        let output = Event<String>()
        let finish = Event<Void>()
    }
    
    public let events: Events = Events()
    
    public init(command: String) {
        self.arguments = command.split(separator: " ").map { String($0) }
    }
    
    @discardableResult
    public static func execSync(_ command: String) -> String {
        
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: .utf8) ?? ""
        
        return output
        
    }
    
    public func start() {
        
        let outputPipe = Pipe()
        
        var currentOutput = ""
        
        outputPipe.fileHandleForReading.readabilityHandler = {[unowned self] handle in
            let output = handle.availableData
            let outputString = String(data: output, encoding: .utf8) ?? ""
            currentOutput += outputString
            let lines : [String] = currentOutput.split(separator: "\n").map { String($0) }
            for line in lines {
                self.events.output.emit(line)
            }
            currentOutput = ""
        }
        
        let task = Process()
        self.task = task
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", arguments.joined(separator: " ")]
        task.standardOutput = outputPipe
        task.terminationHandler = { process in
            self.events.finish.emit()
        }
        
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        task.launch()
        
    }
    
    func cancel() {
        task?.terminate()
    }
    
}
