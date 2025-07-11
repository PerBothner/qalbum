#KAWALIB = /home/bothner/kawa-bin
#KAWALIB = /home/bothner/Kawa/unmodified
KAWALIB = /home/bothner/Kawa/web/qexo/qalbum/kawa.jar
JAVA = java
JAVAC = javac
KAWA = CLASSPATH=$${KAWAJAR-$(KAWALIB)}:.. $(JAVA) kawa.repl
JAR = jar
QEXO = $(KAWA) --xquery
QALBUM_PACKAGE_DIR = ../qalbum
QALBUM_PACKAGE_ROOT = ..
QALBUM_VERSION = 1.2
#ExifExtractor_JAR = metadata-extractor-2.1.1.jar
#ExifExtractor_JAR = metadata-extractor-2.4.0-beta-1.jar
ExifExtractor_JARS = metadata-extractor.jar:xmpcore.jar
#ExifExtractor_JARS = /home/bothner/Software/metadata-extractor/build/libs/metadata-extractor-2.1.1.jar

all: qalbum-$(QALBUM_VERSION).jar qalbum

qalbum-$(QALBUM_VERSION).jar: \
  $(QALBUM_PACKAGE_DIR)/ImageInfo.class \
  $(QALBUM_PACKAGE_DIR)/SelectFiles.class \
  $(QALBUM_PACKAGE_DIR)/PictureInfo.class \
  $(QALBUM_PACKAGE_DIR)/pictures.class \
  $(QALBUM_PACKAGE_DIR)/create.class \
  $(QALBUM_PACKAGE_DIR)/qalbum.class \
  $(QALBUM_PACKAGE_DIR)/Thumbnail.class
	cd .. && $(JAR) cmf qalbum/jar-manifest qalbum/qalbum-$(QALBUM_VERSION).jar \
	  qalbum/ImageInfo.class \
	  qalbum/PictureInfo.class \
	  qalbum/pictures.class \
	  qalbum/create.class \
	  qalbum/qalbum.class \
	  qalbum/Thumbnail.class

CLASSPATH = "..:$(ExifExtractor_JARS):$(KAWALIB)"

DIST_FILES = index.html Makefile qalbum-$(QALBUM_VERSION).jar \
  metadata-extractor.jar xmpcore.jar \
  qalbum.java ImageInfo.java PictureInfo.java create.java Thumbnail.java \
  pictures.xql qalbum.in qalbum picture.js group.js help.html jar-manifest README

SampleUsage.class: SampleUsage.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) SampleUsage.java

qalbum-$(QALBUM_VERSION).tgz: qalbum-$(QALBUM_VERSION).jar $(DIST_FILES)
	cd .. && tar czf qalbum/qalbum-$(QALBUM_VERSION).tgz \
          `for f in $(DIST_FILES); do echo qalbum/$$f; done`

$(QALBUM_PACKAGE_DIR)/qalbum.class: $(QALBUM_PACKAGE_DIR)/qalbum.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/qalbum.java

$(QALBUM_PACKAGE_DIR)/create.class: $(QALBUM_PACKAGE_DIR)/create.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/create.java

$(QALBUM_PACKAGE_DIR)/Thumbnail.class: $(QALBUM_PACKAGE_DIR)/Thumbnail.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/Thumbnail.java

$(QALBUM_PACKAGE_DIR)/ImageInfo.class: $(QALBUM_PACKAGE_DIR)/ImageInfo.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/ImageInfo.java

$(QALBUM_PACKAGE_DIR)/PictureInfo.class: $(QALBUM_PACKAGE_DIR)/PictureInfo.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/PictureInfo.java

$(QALBUM_PACKAGE_DIR)/SelectFiles.class: $(QALBUM_PACKAGE_DIR)/SelectFiles.java
	CLASSPATH=$(CLASSPATH) $(JAVAC) -d $(QALBUM_PACKAGE_ROOT) $(QALBUM_PACKAGE_DIR)/SelectFiles.java

$(QALBUM_PACKAGE_DIR)/pictures.class: pictures.xql
	scriptdir=`pwd`; \
	CLASSPATH=$(CLASSPATH) \
	$(JAVA) kawa.repl --xquery --main -d .. -P qalbum. -C pictures.xql

qalbum: qalbum.in
	sed -e 's/@QALBUM_VERSION@/$(QALBUM_VERSION)/g' \
	  -e 's/@ExifExtractor_JARS@/$(ExifExtractor_JARS)/g' \
	  -e 's/@KAWA_JAR@/kawa.jar/g' <qalbum.in >qalbum
	chmod +x qalbum

clean:
	rm -f *.class qalbum*.jar qalbum*.tgz qalbum
