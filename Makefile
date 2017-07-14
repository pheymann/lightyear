all: install

install: build
	idris --install lightyear.ipkg

dependencies:
	mkdir dependencies
	(cd dependencies; git clone https://github.com/pheymann/specdris; git fetch; cd specdris; git checkout v0.2.1; ./project --install; cd ../..)

build: Lightyear/*.idr
	idris --build lightyear.ipkg

test: build
	(cd tests; idris --clean test.ipkg; idris --testpkg test.ipkg)

testCI: dependencies
	(cd tests; idris --clean test.ipkg; idris --testpkg test.ipkg)

clean:
	idris --clean lightyear.ipkg
	rm -f tests/*.ibc
