//
//  WordLearned.m
//  academy
//
//  Created by Brian on 6/12/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordLearned.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
@implementation WordLearned
@synthesize wordLearnedDelegate;
- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _word_id = [dict valueForKey:@"word_id"];
    _user_id = [dict valueForKey:@"user_id"];
    _created_at = [self getDateFromDict:dict WithKey:@"created_at"];
    if (_created_at) {

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:_created_at];
        _learnedDay = [components day];
        _learnedMonth = [components month];
        _learnedYear = [components year];
        [self saveToNSUserDefaults];
    }
}
-(NSString *)getUserDefaultStoredKey
{
    return @"storedScores";
}
- (NSDictionary *)getDictionaryFromObject {
    return @{
             @"id" : self.modelId ?: @"",
             @"user_id" : _user_id?:@"",
             @"word_id" : _word_id?: @""
             };
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {

    NSString *apiPath = [NSString stringWithFormat:@"api/wordLearned"];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"here %@", responseObject);
        NSArray *wordLearneds = responseObject;
        NSMutableArray * wordLearnedList = [NSMutableArray new];
        for (NSDictionary * setScoreDict in wordLearneds) {
            WordLearned* wordLeanred = [[WordLearned alloc] initWithDict:setScoreDict];
            [wordLearnedList addObject:wordLeanred];
        }
        [self.delegate getAllSucessfull:self List:wordLearnedList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

-(void) addWordLearnedList:(NSArray*) wordList UserId:(NSString *)user_id
{
    if (wordList.count == 0) {
        [wordLearnedDelegate wordLearnedUploadSuccessful:nil];
    }
    NSString * wordIdListStr = @"";
    for (Word *word in wordList) {
        wordIdListStr = [NSString stringWithFormat:@"%@|%@",wordIdListStr,word.modelId];
    }
    wordIdListStr = [wordIdListStr substringFromIndex:1];
    
    NSDictionary *params = @{@"wordIdListStr":wordIdListStr,
                             @"user_id":user_id
                             };
    
    NSString *apiPath = [NSString stringWithFormat:@"api/uploadWordLearnedList"];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res %@", responseObject);
        NSArray *wordLearneds = responseObject;
        NSMutableArray * wordLearnedList = [NSMutableArray new];
        for (NSDictionary * setScoreDict in wordLearneds) {
            WordLearned* wordLeanred = [[WordLearned alloc] initWithDict:setScoreDict];
            [wordLearnedList addObject:wordLeanred];
        }
        [self.wordLearnedDelegate wordLearnedUploadSuccessful:wordLearnedList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.wordLearnedDelegate wordLearnedUploadWithError:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
    
}
-(NSString *) getDateString
{
    return [NSString stringWithFormat:@"%i-%i-%i",_learnedMonth,_learnedDay,_learnedYear];
}
-(NSString *) getDateStringWithoutYear
{
    return [NSString stringWithFormat:@"%@ %i",[WordLearned getMonthStr:_learnedMonth], _learnedDay];
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"[WordLearned Class] [user:%@][word:%@] [%i-%i-%i]",_user_id,_word_id,_learnedDay,_learnedMonth,_learnedYear];
}

+(NSDictionary *) convertLearnedArrayForChart:(NSArray *) learnedArray maxColumn:(int) maxColumn
{
    NSArray *sortedArray = [learnedArray sortedArrayUsingComparator:^NSComparisonResult(WordLearned* obj1, WordLearned* obj2) {
        return [obj1.created_at compare:obj2.created_at] == NSOrderedAscending;
    }];
    //NSLog(@"sortedArray = %@",sortedArray);
    NSMutableArray *xLabels = [NSMutableArray new];
    NSMutableArray *wlArrayList = [NSMutableArray new];
    
    NSDate *checkDate = [NSDate date];
    WordLearned *lastWl = [sortedArray firstObject];
    NSDateComponents *checkDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:checkDate];
    NSDateComponents *lastWlComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:lastWl.created_at];
    while ([checkDateComponents year] >= [lastWlComponents year] && [checkDateComponents month] >= [lastWlComponents month] && [checkDateComponents day] > [lastWlComponents day]) {
        NSLog(@"date = %i-%i-%i",[checkDateComponents year], [checkDateComponents month], [checkDateComponents day]);
        
        [xLabels addObject:[WordLearned getStringFromDateWithoutYear:checkDate]];
        NSMutableArray *wlContainer = [NSMutableArray new];
        [wlArrayList addObject:wlContainer];
        
        checkDate =[checkDate dateByAddingTimeInterval:60*60*24*-1];
        checkDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:checkDate];
    }
    
    
    for (WordLearned *wl in sortedArray) {
        if (xLabels.count <= maxColumn) {
            if ([sortedArray indexOfObject:wl] == 0) {
                [xLabels addObject:[wl getDateStringWithoutYear]];
                NSMutableArray *wlContainer = [NSMutableArray new];
                [wlArrayList addObject:wlContainer];
                [wlContainer addObject:wl];
                checkDate = wl.created_at;
            }
            else
            {
                NSMutableArray *lastContainer = [wlArrayList lastObject];
                WordLearned *lastWl = [lastContainer lastObject];
                checkDate = lastWl.created_at;
                while (![[wl getDateString] isEqualToString:[WordLearned getStringFromDate:checkDate]]) {
                    checkDate = [checkDate dateByAddingTimeInterval:60*60*24*-1];
                    [wlArrayList addObject:[NSMutableArray new]];
                    [xLabels addObject:[WordLearned getStringFromDateWithoutYear:checkDate]];
                }
                
                if ([[wl getDateString] isEqualToString:[lastWl getDateString]]) {
                    [lastContainer addObject:wl];
                }
                else
                {
                    NSMutableArray *wlContainer = [wlArrayList lastObject];
                    [wlContainer addObject:wl];
                }
            }
        }
    }
    while (xLabels.count < maxColumn) {
        checkDate = [checkDate dateByAddingTimeInterval:60*60*24*-1];
        [wlArrayList addObject:[NSMutableArray new]];
        [xLabels addObject:[WordLearned getStringFromDateWithoutYear:checkDate]];
    }
    //NSLog(@"xLabels = %@",xLabels);
    //NSLog(@"wlArrayList = %@",wlArrayList);
    
    NSMutableArray *wlCountArray = [NSMutableArray new];
    for (NSArray *wlArray in wlArrayList) {
        [wlCountArray addObject:[NSNumber numberWithInt:wlArray.count]];
    }
    if (xLabels.count > maxColumn) {
        [xLabels removeObjectsInRange:NSMakeRange(maxColumn, xLabels.count - maxColumn)];
    }
    if (wlCountArray.count > maxColumn) {
        [wlCountArray removeObjectsInRange:NSMakeRange(maxColumn, wlCountArray.count - maxColumn)];
    }
    [xLabels reverse];
    [wlCountArray reverse];
    
    return @{
             @"xLabels":xLabels,
             @"yValues":wlCountArray
             };
}
+ (NSString *)getStringFromDate:(NSDate *)date {
   NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [NSString stringWithFormat:@"%i-%i-%i",[components month],[components day],[components year]];
}
+ (NSString *)getStringFromDateWithoutYear:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [NSString stringWithFormat:@"%@ %i",[WordLearned getMonthStr:[components month]],[components day]];
}
+(NSString *) getMonthStr:(int) mon
{
    switch (mon) {
        case 1: return @"JAN";
        case 2: return @"FEB";
        case 3: return @"MAR";
        case 4: return @"APR";
        case 5: return @"MAY";
        case 6: return @"JUN";
        case 7: return @"JUL";
        case 8: return @"AUG";
        case 9: return @"SEP";
        case 10: return @"OCT";
        case 11: return @"NOV";
        case 12: return @"DEC";

    }
    return @"";
}
@end


