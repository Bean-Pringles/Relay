import global
import osproc
import strutils

proc javaDepExport*() =
    if not commandExists("java"):
        return

    writeToFile("\nJava:\n")

    try:
        let javaVer = execProcess("java -version 2>&1").strip().split("\n")[0].replace("\"", "")
        
        writeToFile("    (" & javaVer & "):\n")
        
        # Java doesn't have global packages like other languages
        # Could check Maven local repo, but it's typically project-specific
        writeToFile("        (Java packages are project-specific)\n")
    except:
        discard