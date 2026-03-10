import os 
import strutils

let appFile = getAppFilename()
let appDir = splitPath(appFile).head
let actionsPath = joinPath(appDir, "actions.nim")
let targetsPath = joinPath(appDir, "targets")

# Start with imports section
var importsSection = ""
var callsSection = "\nproc runAllActions*() =\n"

# Walk the targets directory
for kind, path in walkDir(targetsPath):
    if kind == pcFile and path.endsWith(".nim"):
        if not (path.endsWith("global.nim")):
            let moduleName = splitFile(path).name
            
            # Build import
            importsSection.add("import targets/" & moduleName & "\n")
            
            # Build call to each module's action
            callsSection.add("    " & moduleName & "DepExport()\n")

# Write complete file
writeFile(actionsPath, importsSection & callsSection)