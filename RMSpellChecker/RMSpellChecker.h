//
//  RMSpellChecker.h
//  RMSpellChecker
//
//  Created by Ross Maniaci on 5/4/17.
//  Copyright © 2017 Ross Maniaci.
//
//  This software may be modified and distributed under the terms of the MIT license.  See the LICENSE file for details.
//

#import <Foundation/Foundation.h>

@interface RMSpellChecker : NSObject

@property (strong, nonatomic) NSString *wordPath;
@property (strong, nonatomic) NSMutableDictionary *wordDictionary;
@property (strong, nonatomic) NSMutableDictionary *simpleDictionary;

- (id)initWithWordPath:(NSString *)aWordPath;

+ (instancetype)RMSpellCheckerWithWordPath:(NSString *)aWordPath;

- (NSString *)checkSpelling:(NSString *)input;

- (void)populateDictionaries;

- (NSString *)simplifyString:(NSString *)complexString;

- (NSString *)removeVowels:(NSString *)stringWithVowels;

- (BOOL)isVowel:(char)letter;

- (NSString *)removeDuplicates:(NSString *)stringWithDuplicates;

@end
