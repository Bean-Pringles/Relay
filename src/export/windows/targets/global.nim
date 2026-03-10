import os

proc writeToFile*(text: string) = 
    var f: File

    if open(f, joinPath(getCurrentDir(), "dependencies.dep"), fmAppend):
        f.writeLine(text)
        f.close()

proc commandExists*(cmd: string): bool =
    return findExe(cmd) != ""