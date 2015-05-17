//
//  LSet.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LSet.h"
#import "Word.h"

@implementation LSet

@synthesize name, desc, orderNo, wordList, package_id;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];

    name = dict[@"name"] ?: nil;
    desc = dict[@"description"] ?:nil;
    package_id = dict[@"package_id"] ?: nil;
    orderNo = dict[@"order_number"] ? [dict[@"order_number"] intValue] : -1;
    
    
    wordList = [NSMutableArray new];
    
    NSArray * words = dict[@"words"]?: @[];
    
    for (NSDictionary * wordDict in words) {
        Word * newWord = [[Word alloc] initWithDict:wordDict];
        [wordList addObject:newWord];
    }
    
}

@end
