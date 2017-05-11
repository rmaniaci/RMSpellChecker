//
//  main.m
//  RMSpellChecker
//
//  Created by Ross Maniaci on 5/4/17.
//  Copyright © 2017 Ross Maniaci.
//
//  This software may be modified and distributed under the terms of the MIT license.  See the LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "RMSpellChecker.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Capture user input from the command line.
        char inputstr[50] = {0};
        scanf("%s", inputstr);
        NSString *inputString = [NSString stringWithUTF8String:inputstr];
        
        // Add path to the dictionary source (stay with /usr/share/dict/words since this is using Bash)
        NSString *wordPath = @"/usr/share/dict/words";
        
        // Initialize an RMSpellChecker object with the path to dictionary source file as input.
        RMSpellChecker *spellChecker = [RMSpellChecker RMSpellCheckerWithWordPath:wordPath];
        
        // Check the spelling of the input string using the checkSpelling: method.
        NSString *outputString = [spellChecker checkSpelling:inputString];
        
        // Output the spelling suggestion from checkSpelling: to the command line.
        printf("%s\n", [outputString UTF8String]);
    }
    
    return 0;
}
