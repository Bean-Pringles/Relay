import global
import osproc
import strutils

proc perlDepExport*() =
    if not commandExists("cpan"):
        return

    writeToFile("\nPerl:\n")

    try:
        let perlVer = execProcess("perl --version").strip().split("\n")[1]
        
        writeToFile("    (" & perlVer & "):\n")

        # List installed modules
        var output = execProcess("cpan -l").strip()
        
        if output.len > 0:
            output = output.replace("\n", "\n        ")
            output = "        " & output
            writeToFile(output & "\n")
        else:
            writeToFile("        (no packages)\n")
    except:
        discard