QMAKE_OVERRIDES=QTDIR=$(PWD)/qt_4.7.3_arm QMAKE_LIBDIR=$(PWD)/qt_4.7.3_arm/lib QMAKE_INCDIR_QT=$(PWD)/qt_4.7.3_arm/include QMAKE_LFLAGS=-Wl,-O2,-rpath,$(PWD)/qt_4.7.3_arm/lib:$(SDK_PATH)/$(TARGET_SYS)/usr/lib
#DO_OPENGL=CONFIG+=enable_opengl

default: pnd

qmake:
	qmake-qt4 $(DO_OPENGL) -after $(QMAKE_OVERRIDES) -spec $(SDK_PATH)/share/qt4/mkspecs/linux-pandora-g++ panorama/panorama.pro

prepare_build:
	for qtlib in $$(ls qt_4.7.3_arm/lib/*.so); do if [ ! -e qt_4.7.3_arm/lib/$$(basename $$qtlib).4 ]; then ln -s $$(basename $$qtlib) qt_4.7.3_arm/lib/$$(basename $$qtlib).4; fi; done

build: prepare_build qmake
	cd panorama; make; cd ..

prepare_pnd: build
	for qtlib in $$(ls qt_4.7.3_arm/lib/*.so); do if [ ! -e PND_content/lib/$$(basename $$qtlib).4 ]; then cp -u $$qtlib PND_content/lib/$$(basename $$qtlib).4; fi; done
	cp panorama/target/panorama PND_content/panorama
	cp -Rf panorama/target/interfaces/* PND_content/interfaces_default/
	cp -Rf panorama/target/plugins/* PND_content/plugins/
	cp -Rf qt_4.7.3_arm/plugins/* PND_content/qt/plugins/
	cp -Rf qt_4.7.3_arm/imports/* PND_content/imports
	cp panorama/target/lib/libpnd.so.1 PND_content/lib/


pnd: prepare_pnd
	pnd_make -c -p panorama.pnd -d PND_content -i PND_content/icon.png -x PND_content/PXML.xml


clean_build:
	if [ -e panorama/Makefile ]; then cd panorama; make clean; cd ..; fi
	find panorama -name Makefile -delete
	rm -f qt_4.7.3_arm/lib/*.4
	find panorama/ -name *.so -delete
	find panorama/ -name *.a -delete


clean_pnd:
	rm -f PND_content/lib/*
	rm -f PND_content/panorama
	rm -Rf PND_content/interfaces_default/*
	rm -Rf PND_content/plugins/*
	rm -Rf PND_content/qt/plugins/*
	rm -Rf PND_content/imports/*

clean: clean_build clean_pnd

