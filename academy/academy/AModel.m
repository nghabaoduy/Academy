//
//  AModel.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"

@implementation AModel

- (void)findId:(NSString *)valId {
    AModel * newModel = [AModel new];
    newModel.modelId = valId;
    
    [self.delegate findIdSuccessful:newModel];
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    
    //[self.delegate getAllSucessfull:@[]];
}

- (void)createModel {
    [self.delegate createModelSuccessful:self];
}

- (void)updateModel {
    [self.delegate updateModelSuccessful:self];
}

- (void)deleteModel {
    [self.delegate deleteModelSuccessful:self];
}

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    
}

- (NSDictionary *)getDictionaryFromObject {
    return @{};
}

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setObjectWithDictionary:dict];
    }
    return self;
}

- (NSString *)getStringFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    if ([dict[key] isEqual:[NSNull null]] || !dict[key]) {
        return @"";
        //return @"Empty";
    }
    return [NSString stringWithFormat:@"%@",dict[key]];
}

- (NSNumber *)getNumberFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    if ([dict[key] isEqual:[NSNull null]] || !dict[key]) {
        return @(-1);
    }
    return dict[key];
}

- (NSArray *)getArrayFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    if ([dict[key] isEqual:[NSNull null]] || !dict[key]) {
        return @[];
    }
    return dict[key];
}
- (NSDate *)getDateFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",[dict valueForKey:key]]];
    return date;
}
- (NSDictionary *)getDictFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    if ([dict[key] isEqual:[NSNull null]] || !dict[key]) {
        return @{};
    }
    return dict[key];
}

-(NSString *)getUserDefaultStoredKey
{
    return @"";
}
-(void) saveToNSUserDefaults
{
    if ([[DataEngine getInstance] isOffline]) {
        return;
    }
    NSString *userDefaultStoredKey = [self getUserDefaultStoredKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * storedArray = [defaults objectForKey:userDefaultStoredKey];
    NSMutableArray * modifiedArray;
    if (!storedArray) {
        modifiedArray = [NSMutableArray new];
    }
    else
    {
        modifiedArray = [storedArray mutableCopy];
    }
    BOOL isStored = NO;
    int index = 0;
    for (NSDictionary * objDict in storedArray) {
        NSString * loopId = [NSString stringWithFormat:@"%@",objDict[@"id"]];
        if (loopId && self.modelId)
        if ([loopId isEqualToString:self.modelId]) {
            isStored = YES;
            index = [storedArray indexOfObject:objDict];
        }
    }
    if (isStored) {
        [modifiedArray removeObjectAtIndex:index];
    }
    [modifiedArray addObject:[self getDictionaryFromObject]];
    
    [defaults setObject:modifiedArray forKey:userDefaultStoredKey];
    [defaults synchronize];
}

-(NSArray *) filterNSArrayWithFilter:(NSArray *) aArray Filter:(NSDictionary*) filter
{
    NSArray *resultArray = [aArray copy];
    for (NSString *key in [filter allKeys]) {
        resultArray = [self filterArrayByADictionary:resultArray andKey:[NSString stringWithFormat:@"%@ = '%@'",key,[filter valueForKey:key]]];
    }
    return resultArray;
    
}
-(NSArray *)filterArrayByADictionary:(NSArray *)aArray andKey:(NSString *)aPredicte
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:aPredicte];
    return [aArray filteredArrayUsingPredicate:filter];
}

@end
