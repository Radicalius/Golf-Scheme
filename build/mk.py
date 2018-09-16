import re

VERSIONS = {"gscm":["-chez","-scm"],"README":[".md"]}
DEST = "../"
SOURCES = ["gscm","README"]

s_keywds = []
gs_keywds = []
args = []

f = open("keyword_table.txt","r")
for line in f.readlines()[2:]:
    parts = line.split("|")
    s_keywds.append("'"+parts[1].strip())
    gs_keywds.append("#\\"+parts[2].strip())
    args.append(parts[3].strip())
f.close()

open("gen/scheme_keywords","w").write(" ".join(s_keywds))
open("gen/golf_scheme_keywords","w").write(" ".join(gs_keywds))
open("gen/keyword_args","w").write(" ".join(args))


for source in SOURCES:
    for version in VERSIONS[source]:
        f = open(source,"r")
        cont = f.read()
        f.close()
        repls = re.findall("{{([^}]*)}}",cont)
        for repl in repls:
            file = repl.replace("version",version.replace("-",""))
            g = open(file,"r")
            cont = cont.replace("{{"+repl+"}}", g.read())
            g.close()
        h = open(DEST+source+version,"w")
        h.write(cont)
        h.close()
