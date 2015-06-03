//
//  Meaning.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 18/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Meaning.h"

@implementation Meaning


- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _language = [self getStringFromDict:dict WithKey:@"language"];
    _content = [self getStringFromDict:dict WithKey:@"content"];
    _wordId = [self getStringFromDict:dict WithKey:@"wordId"];
    _example = [self getStringFromDict:dict WithKey:@"example"];
    self.wordSubDict = [self getDictFromString:[self getStringFromDict:dict WithKey:@"word_sub_dict"]];
}
-(NSDictionary *) getDictFromString:(NSString *) dictStr
{
    NSMutableDictionary *wordDict = [NSMutableDictionary new];
    NSArray * groups = [dictStr componentsSeparatedByString:@"|"];
    for (NSString * group in groups) {
        NSArray * coms = [group componentsSeparatedByString:@":"];
        if (coms.count == 2) {
            [wordDict setObject:coms[1] forKey:coms[0]];
        }
    }
    if ([wordDict allKeys].count== 0) {
        return nil;
    }
    return [wordDict copy];
}
@end
