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

@synthesize package, awsId, name, desc, orderNo, wordList;

-(id) initWithDict:(NSDictionary *) dict package:(Package *) pack
{
    [self loadDictInfo:dict package:pack];
    return self;
}

-(void) loadDictInfo:(NSDictionary *) dict package:(Package *) pack
{
    package = pack;
    awsId = [dict valueForKey:@"id"];
    name = [dict valueForKey:@"name"];
    desc = [dict valueForKey:@"description"];
    orderNo = [[dict valueForKey:@"order_number"] intValue];
    
    wordList = [NSMutableArray new];
    for (NSDictionary *wordDict in [dict objectForKey:@"words"]) {
        Word *word = [[Word alloc] initWithDict:wordDict set:self];
        [wordList addObject:word];
    }
}


@end
