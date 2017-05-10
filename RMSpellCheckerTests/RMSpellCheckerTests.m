//
//  RMSpellCheckerTests.m
//  RMSpellCheckerTests
//
//  Created by Ross Maniaci on 5/4/17.
//  Copyright © 2017 Ross Maniaci.
//
//  This software may be modified and distributed under the terms of the MIT license.  See the LICENSE file for details.
//

#import <XCTest/XCTest.h>
#import "RMSpellChecker.h"

@interface RMSpellCheckerTests : XCTestCase {
    @private
    
    NSString *testWordPath;
    NSString *testInputString;
    RMSpellChecker *testSpellChecker;
}

@end

@implementation RMSpellCheckerTests

// Initialize objects that are common to all test methods.
- (void)setUp {
    [super setUp];
    
    testWordPath = @"/usr/share/dict/words"; // Path to dictionary source file.
    testInputString = @"CUNsperrICY"; // Misspelled input string word with incorrect capitalization, incorrect vowels, and duplicate letters.
    testSpellChecker = [RMSpellChecker RMSpellCheckerWithWordPath:testWordPath]; // An RMSpellChecker object with the path to dictionary source file as input.
}

// No teardown needed.
- (void)tearDown {
    [super tearDown];
}

// Test the method to check the spelling of an input string and return a suggestion if possible.
- (void)testCheckSpelling {
    NSString *testOutputString = [testSpellChecker checkSpelling:testInputString];
    NSString *expectedOutputString = @"conspiracy";
    XCTAssertEqualObjects(testOutputString, expectedOutputString, @"The test output string did not match the expected output string.");
}

// Test the shortcut method that simplifies a string by replacing vowels with "^" placeholders and removing duplicate letters and placeholders.
- (void)testSimplifyString {
    NSString *testSimpleString = [testSpellChecker simplifyString:[testInputString lowercaseString]];
    NSString *expectedSimpleString = @"c^nsp^r^cy";
    XCTAssertEqualObjects(testSimpleString, expectedSimpleString, @"The test simple string did not match the expected simple string");
}

// Test if vowels are removed from a string and replace them with "^" placeholders.
- (void)testRemoveVowels {
    NSString *testNoVowels = [testSpellChecker removeVowels:[testInputString lowercaseString]];
    NSString *expectedNoVowels = @"c^nsp^rr^cy";
    XCTAssertEqualObjects(testNoVowels, expectedNoVowels, @"The test string with no vowels did not match the expected string with no vowels");
}

// Test if a given input character letter is an English vowel (a, e, i, o, u) or a consonant.
- (void)testIsVowel {
    char testLetter = 'a';
    BOOL testIfVowel = [testSpellChecker isVowel:testLetter];
    XCTAssertTrue(testIfVowel, @"The isVowel method did not return the expected true value.");
}

// Test if duplicate characters are removed from a string.
- (void)testRemoveDuplicates {
    NSString *testNoDuplicates = [testSpellChecker removeDuplicates:[testInputString lowercaseString]];
    NSString *expectedNoDuplicates = @"cunspericy";
    XCTAssertEqualObjects(testNoDuplicates, expectedNoDuplicates, @"The test string with no duplicates did not match the expected string with no duplicates");
}

// Test the performance of the method that populates both the word dictionary and the simple dictionary from a source file.
- (void)testPopulateDictionariesPerformance {
    [self measureBlock:^{
        [testSpellChecker populateDictionaries];
    }];
}

@end
