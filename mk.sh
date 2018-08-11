for file in chez scm; do
	cat gscm.scm "$file.tail" > "gscm-$file"
done
