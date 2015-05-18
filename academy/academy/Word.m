//
//  Word.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Word.h"
#import "Meaning.h"

@implementation Word

@synthesize name, phonentic, wordType;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    name = [self getStringFromDict:dict WithKey:@"name"];
    phonentic = [self getStringFromDict:dict WithKey:@"phonentic"];
    wordType = [self getStringFromDict:dict WithKey:@"word_type"];

    _meaningList = [NSMutableArray new];
    NSArray * meanings = [self getArrayFromDict:dict WithKey:@"meaning_list"];
    for (NSDictionary * meaningDict in meanings) {
        Meaning * newMeaning = [[Meaning alloc] initWithDict:meaningDict];
        [_meaningList addObject:newMeaning];
    }
}

-(NSString *) getMeaning: (NSString *) lang bExample:(BOOL) bExample
{
    if (bExample) {
        for (Meaning * meaning in _meaningList) {
            if ([meaning.language isEqualToString:lang] ) {
                if ([meaning.example isEqualToString:@""]) {
                    return meaning.content;
                }
                return [NSString stringWithFormat:@"%@\n\nExample:\n%@", meaning.content, meaning.example];
            }
        }
    }
    else
    {
        for (Meaning * meaning in _meaningList) {
            if ([meaning.language isEqualToString:lang] ) {
                return meaning.content;
            }
        }
    }
    return @"";
}
-(NSString *) getWordType
{
    return self.wordType;
}
@end
