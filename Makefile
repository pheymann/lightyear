all: install

install: build
	idris --install lightyear.ipkg

dependencies:
	mkdir dependencies
	(cd dependencies; git clone https://github.com/pheymann/specdris; git fetch; cd specdris; git checkout v0.2.2; ./project --build; cd ../..)

build: Lightyear/*.idr
	idris --build lightyear.ipkg

test: build
	(cd tests; idris --clean test.ipkg; idris --testpkg test.ipkg --idrispath ../dependencies/specdris/src)

testCI: dependencies
	(cd tests; idris --clean test.ipkg; idris --testpkg test.ipkg --idrispath ../dependencies/specdris/src)

clean:
	idris --clean lightyear.ipkg
	rm -f tests/*.ibc
