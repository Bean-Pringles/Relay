import global
import osproc
import strutils

proc rubyDepExport*() =
    if not commandExists("gem"):
        return

    writeToFile("\nRuby:\n")

    try:
        let rubyVer = execProcess("ruby --version").strip().split(" ")[0..1].join(" ")
        
        writeToFile("    (" & rubyVer & "):\n")

        var output = execProcess("gem list").strip()
        var packages: seq[string] = @[]
        
        for line in output.splitLines():
            let trimmed = line.strip()
            if trimmed.len > 0 and "(" in trimmed:
                # Lines look like: "bundler (2.4.10, 2.3.7)"
                let parts = trimmed.split(" (")
                if parts.len >= 2:
                    let name = parts[0].strip()
                    let versions = parts[1].replace(")", "").split(", ")[0]  # Take first version
                    packages.add("        " & name & "=" & versions)
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard