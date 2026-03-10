import global
import osproc
import strutils

proc phpDepExport*() =
    if not commandExists("composer"):
        return

    writeToFile("\nPHP:\n")

    try:
        let phpVer = execProcess("php --version").strip().split("\n")[0].split(" ")[1]
        
        writeToFile("    (PHP " & phpVer & "):\n")

        var output = execProcess("composer global show --name-only").strip()
        var packages: seq[string] = @[]
        
        # Get detailed info for each package
        for pkgName in output.splitLines():
            let trimmed = pkgName.strip()
            if trimmed.len > 0:
                try:
                    let info = execProcess("composer global show " & trimmed).strip()
                    for line in info.splitLines():
                        if line.startsWith("versions :"):
                            let ver = line.replace("versions :", "").strip().split(",")[0].strip().strip(chars={'*', ' '})
                            packages.add("        " & trimmed & "=" & ver)
                            break
                except:
                    discard
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard