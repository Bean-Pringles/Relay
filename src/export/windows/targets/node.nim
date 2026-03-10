import global
import osproc
import strutils

proc nodeDepExport*() =
    if not commandExists("npm"):
        return

    writeToFile("\nNode.js:\n")

    try:
        let nodeVer = execProcess("node --version").strip()
        
        writeToFile("    (" & nodeVer & "):\n")

        let listOutput = execProcess("npm list -g --depth=0 2>&1").strip()
        var packages: seq[string] = @[]
        
        for line in listOutput.splitLines():
            let trimmed = line.strip()
            # Lines can look like: "├── package@1.2.3" or "└── package@1.2.3" or just "package@1.2.3"
            if "@" in trimmed:
                var cleaned = trimmed
                # Remove tree characters if present
                cleaned = cleaned.replace("├──", "").replace("└──", "").replace("│", "").strip()
                
                # Skip if it's the npm global path line or empty
                if cleaned.len > 0 and not cleaned.startsWith("/") and not cleaned.startsWith("C:"):
                    let atPos = cleaned.find("@", 1)  # Find @ after first char (to skip scoped packages)
                    if atPos > 0:
                        let name = cleaned[0..<atPos]
                        let version = cleaned[atPos+1..^1]
                        packages.add("        " & name & "=" & version)
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard