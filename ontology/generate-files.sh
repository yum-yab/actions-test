#! /usr/bin/bash

repoPomDir=ontology

newVersionDirectory=$repoPomDir/data/ontology/dbo-snapshots/$fullVersion


# Generating the turtle and dl files from the ontology
java -cp ./DisplayAxioms.jar DisplayAxioms $newVersionDirectory/dbo-snapshots.owl | LC_ALL=C sort -u > $newVersionDirectory/dbo-snapshots.dl
rapper -i rdfxml -o turtle $newVersionDirectory/dbo-snapshots.owl > $newVersionDirectory/dbo-snapshots.ttl

