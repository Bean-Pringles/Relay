import global
import osproc
import strutils
import os

proc goDepExport*() =
    if not commandExists("go"):
        return

    writeToFile("\nGo:\n")

    try:
        let goVer = execProcess("go version").strip().split(" ")[2]
        let cleanVer = "go " & goVer
        
        writeToFile("    (" & cleanVer & "):\n")

        var binDir = execProcess("go env GOBIN").strip()
        if binDir.len == 0:
            let gopath = execProcess("go env GOPATH").strip()
            binDir = gopath / "bin"

        if not dirExists(binDir):
            writeToFile("        (no packages)\n")
            return

        var packages: seq[string] = @[]
        
        for file in walkDir(binDir):
            if file.kind == pcFile or file.kind == pcLinkToFile:
                let binPath = file.path
                
                try:
                    let modInfo = execProcess("go version -m " & quoteShell(binPath)).strip()
                    var modPath = ""
                    var modVer = ""
                    
                    for line in modInfo.splitLines():
                        let trimmed = line.strip()
                        if trimmed.startsWith("mod") and modPath.len == 0:
                            let parts = trimmed.split(Whitespace)
                            if parts.len >= 3:
                                modPath = parts[1]
                                modVer = parts[2].strip(chars={'v'})
                                break
                    
                    if modPath.len > 0 and modVer.len > 0:
                        let pkgName = modPath.split("/")[^1]
                        packages.add("        " & pkgName & "=" & modVer)
                except:
                    discard
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard