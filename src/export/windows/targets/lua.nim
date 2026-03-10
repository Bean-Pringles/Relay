import global
import osproc
import strutils

proc luaDepExport*() =
    if not commandExists("luarocks"):
        return

    writeToFile("\nLua:\n")

    try:
        let luaVer = execProcess("lua -v").strip()
        
        writeToFile("    (" & luaVer & "):\n")

        var output = execProcess("luarocks list --porcelain").strip()
        var packages: seq[string] = @[]
        
        for line in output.splitLines():
            let parts = line.strip().split("\t")
            if parts.len >= 2:
                packages.add("        " & parts[0] & "=" & parts[1])
        
        if packages.len > 0:
            writeToFile(packages.join("\n") & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard