import actions
import os

# Clear the dep file
writeFile(joinPath(getCurrentDir(), "dependencies.dep"), "")

runAllActions()