//
//  Word.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize set, awsId, name, phonentic;

-(id) initWithDict:(NSDictionary *) dict set:(LSet *) inSet
{
    [self loadDictInfo:dict set:inSet];
    return self;
}

-(void) loadDictInfo:(NSDictionary *) dict set:(LSet *) inSet
{
    set = inSet;
    awsId = [dict valueForKey:@"id"];
    name = [dict valueForKey:@"name"];
    phonentic = [dict valueForKey:@"phonentic"];
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
