//
//  Package.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Package.h"
#import "LSet.h"

@implementation Package

@synthesize awsId, name, desc, category, price, wordsTotal, setList;

-(id) initWithDict:(NSDictionary *) dict
{
    [self loadDictInfo:dict];
    return self;
}

-(void) loadDictInfo:(NSDictionary *) dict
{
    awsId = [dict valueForKey:@"id"];
    name = [dict valueForKey:@"name"];
    desc = [dict valueForKey:@"description"];
    category = [dict valueForKey:@"category"];
    price = [dict valueForKey:@"price"];
    wordsTotal = [[dict valueForKey:@"no_of_words"] intValue];
    
    setList = [NSMutableArray new];
    for (NSDictionary *setDict in [dict objectForKey:@"sets"]) {
        LSet *set = [[LSet alloc] initWithDict:setDict package:self];
        [setList addObject:set];
    }
}

@end
