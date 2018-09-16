import re

VERSIONS = ["chez","scm"]
DEST = "../"
SOURCE = "gscm.scm"

for version in VERSIONS:
    f = open(SOURCE,"r")
    cont = f.read()
    f.close()
    repls = re.findall("{{([^}]*)}}",cont)
    for repl in repls:
        file = repl.replace("version",version)
        g = open(file,"r")
        cont = cont.replace("{{"+repl+"}}", g.read())
        g.close()
    h = open(DEST+"gscm-"+version,"w")
    h.write(cont)
    h.close()
