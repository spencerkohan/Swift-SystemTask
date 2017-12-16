# SystemTask

A convenience wrapper for executing system tasks.

Everything is currently executed via /bin/bash.

## Usage

### Synchronous execution:

    SystemTask.execSync("echo \"this executes the command and returns the output as a string\"")
    
### Asynchronous execution:

    let task = SystemTask(command: "docker compose up")
    
    // output handling
    _ = task.events.output.on { line in
        // do something with the output
    }
    
    // callback on finish
    _ = task.events.finish.once {
        // do something when the process finishes
    }

    // start the task
    task.start()
    
    // cancel the task
    task.cancel()
