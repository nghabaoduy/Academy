//
//  TestMaker.h
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSet.h"
#import "Word.h"

typedef NS_ENUM(NSUInteger, TestType) {
    TestMultipleChoiceSameLanguage,
    TestMultipleChoiceUserLanguage,
    TestWordFillingSameLanguage,
    TestWordFillingUserLanguage,
    TestWordFillingWordListen,
    TestTypeCount
};

@class TestMaker;

@protocol TestMakerDelegate
-(void) testMaker:(TestMaker *) _testMaker answerCorrectly:(Word*) _word;
-(void) testMaker:(TestMaker *) _testMaker answerWrongly:(Word*) _word;
@end


@interface TestMaker : NSObject
{
    id <TestMakerDelegate> delegate;
}
@property (retain) id delegate;
- (id) initWithSetAndWordList:(LSet *)_set wordList:(NSArray *) _wordList;
-(void) registerCardView:(UIView *) view;
-(UIView *) createNextQuestion;
-(void) displayNextQuestion;
-(BOOL) checkAnswer:(NSString *) _answer;
-(BOOL) isTestFinished;
-(int) getCurQuesNo;
@end
