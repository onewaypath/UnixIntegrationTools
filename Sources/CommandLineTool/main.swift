
import UnixIntegrationTools
print("Hello, world!")

let unix = UnixSession()
let output = unix.shell("pwd")
print(output)
