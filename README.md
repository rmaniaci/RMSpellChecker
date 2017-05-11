# RMSpellChecker

## Synopsis

RMSpellChecker is an Objective-C command line interface designed to run in a Unix environment that captures user input from the command line, checks the spelling (case errors, repeated letters, and vowels) against a dictionary (from the list of words in /usr/share/dict/words) in memory, and returns a correctly spelled suggestion if possible.

## Compile and Run

This program was developed with MacOS Sierra version 10.12.4, Xcode version 8.3.2, and Objective-C 2.0.

First navigate to the RMSpellChecker folder inside the RMSpellChecker project.

```
/path/to/the/files/RMSpellChecker/RMSpellChecker
```

Compile the program using Clang by entering the following command.

```
$ clang -fobjc-arc -framework Foundation main.m RMSpellChecker.m -o RMSpellChecker
```

To run the program using the given format (echo and pipe) enter the following command.

```
$ echo 'misspelledword' | ./RMSpellChecker
correctlyspelledword
```

If the program cannot find a correctly spelled suggestion, it will return "NO SUGGESTION".

## Tests

This program was tested with MacOS Sierra version 10.12.4, Xcode version 8.3.2, and Objective-C 2.0.

First navigate to the RMSpellChecker project.

```
/path/to/the/files/RMSpellChecker/
```

To run unit tests from the command line using the xctest framework, enter the following command:

```
$ xcodebuild test -project RMSpellChecker.xcodeproj -scheme RMSpellChecker -destination 'platform=OS X,arch=x86_64'
```

## License

MIT license as described in the LICENSE file.
