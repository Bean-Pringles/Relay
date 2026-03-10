import global
import osproc
import strutils

proc dotnetDepExport*() =
    if not commandExists("dotnet"):
        return

    try:
        let verResult = execProcess("dotnet --version 2>&1").strip()
        
        # Check if it's an error message
        if "could not be loaded" in verResult or "does not exist" in verResult or "not found" in verResult:
            return
        
        writeToFile("\n.NET:\n")
        writeToFile("    (.NET SDK " & verResult & "):\n")

        var output = execProcess("dotnet tool list -g").strip()
        var packages: seq[string] = @[]
        
        var inData = false
        for line in output.splitLines():
            let trimmed = line.strip()
            if trimmed.startsWith("---"):
                inData = true
                continue
            if inData and trimmed.len > 0:
                let parts = trimmed.split(Whitespace)
                if parts.len >= 2:
                    packages.add("        " & parts[0] & "=" & parts[1])
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard