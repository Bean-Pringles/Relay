import targets/dotnet
import targets/go
import targets/java
import targets/lua
import targets/node
import targets/perl
import targets/php
import targets/python
import targets/ruby
import targets/rust

proc runAllActions*() =
    dotnetDepExport()
    goDepExport()
    javaDepExport()
    luaDepExport()
    nodeDepExport()
    perlDepExport()
    phpDepExport()
    pythonDepExport()
    rubyDepExport()
    rustDepExport()
