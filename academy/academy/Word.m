//
//  Word.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize name, phonentic, wordType;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    name = [self getStringFromDict:dict WithKey:@"name"];
    phonentic = [self getStringFromDict:dict WithKey:@"phonentic"];
    wordType = [self getStringFromDict:dict WithKey:@"word_type"];
}

-(NSString *) getMeaning: (NSString *) lang bExample:(BOOL) bExample
{
    return @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit";
}
-(NSString *) getWordType: (NSString *) lang
{
    return @"n";
}
@end
