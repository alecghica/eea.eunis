#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@

cp=$cp:@XML-APIS.JAR@
cp=$cp:@XML-PARSER.JAR@:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Usage: natura2000importer {folderName}"
else
	$java -cp $cp ro.finsiel.eunis.dataimport.Natura2000Importer $1
fi;
