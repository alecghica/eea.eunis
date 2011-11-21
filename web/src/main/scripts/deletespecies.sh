#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@

cp=$cp:@JRF.JAR@
cp=$cp:@LOG4J.JAR@:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Usage: deletespecies {species1ID} {species2ID} {species3ID} ..."
else
	$java -cp $cp eionet.eunis.scripts.DeleteSpecies $@
fi;
