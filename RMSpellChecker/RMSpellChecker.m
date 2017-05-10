//
//  RMSpellChecker.m
//  RMSpellChecker
//
//  Created by Ross Maniaci on 5/4/17.
//  Copyright © 2017 Ross Maniaci.
//
//  This software may be modified and distributed under the terms of the MIT license.  See the LICENSE file for details.
//

#import "RMSpellChecker.h"

@implementation RMSpellChecker

@synthesize wordPath; // Path to dictionary source file.
@synthesize wordDictionary; // Stores words from source file as values using keys that are lowercase versions of each word.
@synthesize simpleDictionary; // Stores words from source file as values using keys that are simple (vowels replaced by "^" placeholders and duplicate letters and placeholders removed) versions of each word.

// Initializes an RMSpellChecker object with the path to dictionary source file as input.
- (id)initWithWordPath:(NSString *)aWordPath {
    self = [super init];
    
    if (self) {
        // Initialize properties.
        self.wordPath = aWordPath;
        wordDictionary = [[NSMutableDictionary alloc] init];
        simpleDictionary = [[NSMutableDictionary alloc] init];
    }
    
    // Populate dictionaries using the path to dictionary source file.
    [self populateDictionaries];
    
    return self;
}

// Shortcut that both allocates and initializes an RMSpellChecker object with the path to dictionary source file as input.
+ (instancetype)RMSpellCheckerWithWordPath:(NSString *)aWordPath {
    RMSpellChecker *spellChecker = [[RMSpellChecker alloc] initWithWordPath:aWordPath];
    return spellChecker;
}

// Checks spelling of a single word given an input string and returns a suggestion if possible.
- (NSString *)checkSpelling:(NSString *)input {
    // Check for whitespace at beginning, in between, and end of input string.
    // Because usr/share/dict/words focuses on single words, you want one word spellchecked at a time.
    NSString *trimmedString = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange whiteSpaceRange = [trimmedString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Check if input string consists of only letters.
    NSCharacterSet *validChars = [NSCharacterSet letterCharacterSet];
    validChars = [validChars invertedSet];
    NSRange characterRange = [trimmedString rangeOfCharacterFromSet:validChars];
    
    if (whiteSpaceRange.location != NSNotFound || characterRange.location != NSNotFound)
        return @"NO SUGGESTION";
    
    // Check if the input string word has proper spelling but has improper capitalization.
    NSString *lowercase = [trimmedString lowercaseString];
    NSString *capitalizedString = [wordDictionary objectForKey:lowercase];
    
    // If capitalizedString is not returned, then the input string word is misspelled.
    if (!(capitalizedString.length == 0))
        return capitalizedString;
    
    // The next step is to simplify the input string word by replacing vowels with "^" placeholders and removing duplicate letters and placeholders.
    NSString *simpleString = [self simplifyString:lowercase];
    
    // Once the input string word is simplified, you can then check for suggested properly spelled words.
    NSString *output = [simpleDictionary objectForKey:simpleString];
    
    if (!(output.length == 0))
        return output;
    
    // Finally, if output is not returned, then there is no suggested properly spelled word.
    return @"NO SUGGESTION";
}

// Populates both the word dictionary and the simple dictionary from a source file.
- (void)populateDictionaries {
    // Read large list of English words into memory from a source file given a path.
    NSString *dictionaryString = [NSString stringWithContentsOfFile:wordPath encoding:NSUTF8StringEncoding error:NULL];
    
    // Populate an NSArray of words by separating words in the dictionaryString based on the presence of newline characters.
    NSArray *words = [dictionaryString componentsSeparatedByString:@"\n"];
    
    // Populate the dictionaries by using a for-in loop.
    for (NSString *word in words) {
        NSString *lowercase = [word lowercaseString];
        wordDictionary[lowercase] = word;
        NSString *simpleString = [self simplifyString:lowercase];
        simpleDictionary[simpleString] = word;
    }
}

// Shortcut method that simplifies a string by replacing vowels with "^" placeholders and removing duplicate letters and placeholders.
- (NSString *)simplifyString:(NSString *)complexString {
    NSString *simpleString = [self removeDuplicates:[self removeVowels:complexString]];
    return simpleString;
}

// Iterates through a string to remove vowels and replace them with "^" placeholders.
- (NSString *)removeVowels:(NSString *)stringWithVowels {
    // Get the letters of the input string and initialize an empty NSMutableString that will be returned as output.
    NSUInteger len = [stringWithVowels length];
    unichar buffer[len];
    [stringWithVowels getCharacters:buffer range:NSMakeRange(0, len)];
    NSMutableString *noVowels = [[NSMutableString alloc] initWithString:@""];
    
    // Iterate through the input string letters.
    for (int i = 0; i < len; i++) {
        char letter = buffer[i];
        
        // Check if a letter is a vowel or not.
        if ([self isVowel:letter])
            // If a letter is a vowel, append an "^" placeholder to noVowels.
            [noVowels appendString:@"^"];
        
        else
            // If a letter is not a vowel, simply append the letter to noVowels.
            [noVowels appendFormat:@"%c", letter];
    }
    
    return noVowels;
}

// Checks if a given input character letter is an English vowel (a, e, i, o, u) or a consonant.
- (BOOL)isVowel:(char)letter {
    if (letter == 'a' || letter == 'e' || letter == 'i' || letter == 'o' || letter == 'u')
        return YES;
    
    else
        return NO;
}

// Iterates through a string to remove duplicate characters including "^" placeholders.
- (NSString *)removeDuplicates:(NSString *)stringWithDuplicates {
    // Get the letters of the input string and initialize an empty NSMutableString that will be returned as output.
    NSUInteger len = [stringWithDuplicates length];
    NSMutableString *noDuplicates = [[NSMutableString alloc] initWithString:@""];
    
    // If the input string is one letter or empty, simply return it because there is no duplicate by default.
    if ([stringWithDuplicates length] <= 1)
        return stringWithDuplicates;
    
    // Because the first letter of the input string cannot have any duplicates, simply append the letter to noDuplicates.
    unichar buffer[len];
    [stringWithDuplicates getCharacters:buffer range:NSMakeRange(0, len)];
    char previousLetter = buffer[0];
    [noDuplicates appendFormat:@"%c", previousLetter];
    
    // Iterate through the remaning input string letters.
    for (int i = 1; i < len; i++) {
        char letter = buffer[i];
        
        // Check if a letter is a duplicate to a previous letter or not.
        if (letter != previousLetter) {
            // If a letter is not a duplicate to a previous letter, simply append the letter to noDuplicates.
            [noDuplicates appendFormat:@"%c", letter];
            previousLetter = letter;
        }
    }
    
    return noDuplicates;
}

@end
