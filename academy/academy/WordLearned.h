//
//  WordLearned.h
//  academy
//
//  Created by Brian on 6/12/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
#import "Word.h"

@class WordLearned;
@protocol WordLearnedDelegate <NSObject>
- (void)wordLearnedUploadSuccessful:(NSArray *) wordLearnedList;
- (void)wordLearnedUploadWithError:(id)Error StatusCode:(NSNumber*)statusCode;
@end

@interface WordLearned : AModel
@property (nonatomic, weak) id <WordLearnedDelegate> wordLearnedDelegate;

@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * word_id;
@property (nonatomic, strong) NSDate *created_at;
@property int learnedMonth;
@property int learnedDay;
@property int learnedYear;
+(NSDictionary *) convertLearnedArrayForChart:(NSArray *) learnedArray maxColumn:(int) maxColumn;
-(void) addWordLearnedList:(NSArray*) wordList UserId:(NSString *)user_id;
@end
