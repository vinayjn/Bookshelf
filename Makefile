install:
	swift package update
	swift build -c release
	install .build/release/Bookshelf /usr/local/bin/bookshelf