import osproc
import os
import streams
import strutils

# Gets the pretty OS name: windows, macos, ubuntu, arch, etc
proc getOSName(): string =
    when defined(windows):
        return "windows"
    elif defined(macosx):
        return "macos"
    elif defined(linux):
        if fileExists("/etc/os-release"):
            for line in lines("/etc/os-release"):
                if line.startsWith("ID_LIKE="):
                    return line.split("=")[1].strip(chars={'"'}).toLowerAscii
        return "linux"
    else:
        return "unknown"

# Gets the args and makes sure there is the proper amount
let args: seq[string] = commandLineParams()
if args.len < 1:
    quit("[!] Missing action argument", 1)

# Makes sure the given action is valid
let action: string = args[0]
if action notin ["import", "export"]:
    quit("[!] " & action & "is not a valid command", 1)

# Gets the args ran with the command and removes the action
var executableArgs: seq[string] = args
executableArgs.delete(0)

# Finds the path of the exe to run
let osName: string = getOSName()
var path: string = joinPath(parentDir(getAppFilename()), action, osName, action & "_" & osName)
when defined(windows):
    path &= ".exe"

# Makes sure the path exists, if not, the os is not supported
if not fileExists(path):
    quit("[!] Your OS is not supported", 1)

# Runs the command with live output
let p = startProcess(
  path,
  workingDir = parentDir(getAppFilename()),
  args = executableArgs,
  options = {poUsePath, poStdErrToStdOut}
)

var line: string
while p.outputStream.readLine(line):
  echo line

discard p.waitForExit()