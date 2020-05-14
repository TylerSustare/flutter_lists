tst: 
	flutter test --coverage; 
html:
	genhtml -o coverage coverage/lcov.info;
	# requires ➜ brew install lcov 

iosBuildErrors:
	echo "https://github.com/flutter/flutter/issues/50568";
	rm -rf ios/Flutter/App.framework;