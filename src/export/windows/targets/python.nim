import global
import osproc
import strutils

proc pythonDepExport*() =
    if not commandExists("py"):
        return

    let pyList = execProcess("py -0p")
    writeToFile("\nPython:\n")

    for line in pyList.splitLines():
        var l = line.strip()
        if l.len == 0:
            continue

        var parts = l.splitWhitespace()
        if parts.len < 1:
            continue

        var ver = parts[0].strip(chars={'-'})

        try:
            let pyVer = execProcess("py -" & ver & " --version").strip()
            
            writeToFile("    (" & pyVer & "):\n")

            var output = execProcess("py -" & ver & " -m pip list --format=freeze 2>&1").strip()
            
            # Filter out warning/error lines
            var packages: seq[string] = @[]
            for pkgLine in output.splitLines():
                let trimmed = pkgLine.strip()
                if trimmed.len > 0 and "==" in trimmed and not trimmed.startsWith("WARNING") and not trimmed.startsWith("ERROR"):
                    packages.add("        " & trimmed.replace("==", "="))
            
            if packages.len > 0:
                writeToFile(packages.join("\n") & "\n")
            else:
                writeToFile("        (no packages)\n")
        except:
            discard