#! /usr/bin/bash

checkDiff() {
          old_file=$1
          new_file=$2

          regex_pattern="<http:\/\/dbpedia\.org\/ontology\/> <http:\/\/purl\.org\/dc\/terms\/modified> \"  .*\" \."

          diff_output=$(LC_ALL=C comm -3 $old_file $new_file)

          is_equal=true

          while read line; do
                  if ! [[ "$line" =~ $regex_pattern ]]
                  then
                          is_equal=false
                          break
                  fi
          done <<<$diff_output
  }

createDirectories() {

          mkdir -p $repoPomDir/data/ontology/dbo-snapshots/$fullVersion
          cp $repoPomDir/pom.xml $repoPomDir/data/ontology/pom.xml
          cp $repoPomDir/dbo-snapshots/pom.xml $repoPomDir/data/ontology/dbo-snapshots/pom.xml
          cp $repoPomDir/dbo-snapshots/dbo-snapshots.md $repoPomDir/data/ontology/dbo-snapshots/dbo-snapshots.md

}

deleteDirectories() {
	rm -r $repoPomDir/data/
}

repoPomDir=ontology

fullVersion=$(date "+%Y.%m.%d-%H%M%S")

logfile=$repoPomDir/ontology-tracker.log

createDirectories

data_commit_info="Upload new ontology snapshot version: ${fullVersion}"

newVersionDirectory=$repoPomDir/data/ontology/dbo-snapshots/$fullVersion


# Downloads the DBpedia-Ontology from http://mappings.dbpedia.org/server/ontology/dbpedia.owl
wget -O $newVersionDirectory/dbo-snapshots.owl http://mappings.dbpedia.org/server/ontology/dbpedia.owl


# Generates ntriples from new ontology, sorts them and check if its different from the old nt file
rapper -i rdfxml -o ntriples $newVersionDirectory/dbo-snapshots.owl | LC_ALL=C sort -u > $newVersionDir  ectory/dbo-snapshots.nt
LC_ALL=C sort -u "${repoPomDir}"/dbo-snapshots/dbo-snapshots.nt > $newVersionDirectory/old-dbo-snapshot  s.nt
checkDiff $newVersionDirectory/old-dbo-snapshots.nt $newVersionDirectory/dbo-snapshots.nt

# if no new versions -> delete generated directories
# next process in actions checks if directories are still there
if [[ "$is_equal" == true ]]
then
	deleteDirectories
	echo "Date ${fullversion}: No new Version"
	exit 1
else
	echo "Date ${fullversion}: No new Version"
	exit 0
fi
	
