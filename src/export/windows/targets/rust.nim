import global
import osproc
import strutils

proc rustDepExport*() =
    if not commandExists("rustup"):
        return

    let toolchainList = execProcess("rustup toolchain list")
    writeToFile("\nRust:\n")

    for line in toolchainList.splitLines():
        var l = line.strip()
        if l.len == 0:
            continue

        var toolchain = l.split(" ")[0].strip()

        try:
            let rustVer = execProcess("rustup run " & toolchain & " rustc --version").strip()
            let cleanVer = rustVer.split(" ")[0..1].join(" ")
            
            writeToFile("    (" & cleanVer & "):\n")

            var output = execProcess("rustup run " & toolchain & " cargo install --list").strip()
            var packages: seq[string] = @[]
            
            for pkgLine in output.splitLines():
                let trimmed = pkgLine.strip()
                if trimmed.len > 0 and not trimmed.endsWith(".exe"):
                    if "v" in trimmed and trimmed.endsWith(":"):
                        let parts = trimmed.replace(":", "").split(" ")
                        if parts.len >= 2:
                            packages.add("        " & parts[0] & "=" & parts[1].strip(chars={'v'}))
            
            if packages.len > 0:
                writeToFile(packages.join("\n") & "\n")
            else:
                writeToFile("        (no packages)\n")
        except:
            discard