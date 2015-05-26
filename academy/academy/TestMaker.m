//
//  TestMaker.m
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "TestMaker.h"
#import "CardMultipleChoiceView.h"
#import "CardTypeAnswerView.h"

@implementation TestMaker{
    LSet *curSet;
    NSArray *wordList;
    TestType curTestType;
    NSMutableArray *viewTypeList;
    int curWordNo;
    NSString *answer;
}
@synthesize delegate;
- (id)initWithSetAndWordList:(LSet *)_set wordList:(NSArray *) _wordList {
    self = [super init];
    if (self) {
        curSet = _set;
        wordList = _wordList;
        viewTypeList = [[NSMutableArray alloc] initWithCapacity:TestTypeCount];
        curWordNo = -1;
        curTestType = arc4random_uniform(TestTypeCount);
    }
    return self;
}

-(void) registerCardView:(UIView *) view
{

    if ([view class] == [CardMultipleChoiceView class]) {
        viewTypeList[TestMultipleChoiceSameLanguage] = view;
        viewTypeList[TestMultipleChoiceUserLanguage] = view;
    }
    if ([view class] == [CardTypeAnswerView class]) {
        viewTypeList[TestWordFillingSameLanguage] = view;
        viewTypeList[TestWordFillingUserLanguage] = view;
        viewTypeList[TestWordFillingWordListen] = view;
    }
    
}

-(void) updateQuestion
{
    
}

- (NSMutableArray *)shuffleArray:(NSMutableArray *) tarArray
{
    NSUInteger count = [tarArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [tarArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return tarArray;
}
// =========== MULTIPLE CHOICE =========== //
-(void) displayMultipleChoiceCard
{
    CardMultipleChoiceView *card = [viewTypeList objectAtIndex:TestMultipleChoiceSameLanguage];
    Word *word = wordList[curWordNo];
    NSString *question;
    
    switch (curTestType) {
        case TestMultipleChoiceSameLanguage:
            question  = [word getMeaning:@"English" bExample:NO];
            break;
        case TestMultipleChoiceUserLanguage:
            question  = [word getMeaning:@"Vietnamese" bExample:NO];
            break;
        default:
            break;
    }
    NSMutableArray *answerPool = [NSMutableArray new];
    [answerPool addObject:word.name];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    answerPool = [self shuffleArray:answerPool];
    [card displayMultipleChoiceQuestion:question choice1:answerPool[0] choice2:answerPool[1] choice3:answerPool[2] choice4:answerPool[3]];
    answer = word.name;
    
}

-(NSString *) getRandomWordNameDifferentFrom:(NSMutableArray *)curList
{
    NSMutableArray *tempWordList = [wordList mutableCopy];
    while (tempWordList.count > 0) {
        NSUInteger randomIndex = arc4random() % [tempWordList count];
        Word *pickWord = tempWordList[randomIndex];
        BOOL isNotDuplicated = YES;
        for (NSString * curName in curList) {
            if ([curName isEqual:pickWord.name]) {
                isNotDuplicated = NO;
            }
        }
        if (isNotDuplicated) {
            return pickWord.name;
        }else{
            [tempWordList removeObject:pickWord];
        }
    }
    return @"";
}
// =========== FILLING WORD =========== //
-(void) displayFillingWordCard
{
    CardTypeAnswerView *card = [viewTypeList objectAtIndex:TestWordFillingSameLanguage];
    Word *word = wordList[curWordNo];
    NSString * wordType = [word getWordType];
    NSString *question;
    
    switch (curTestType) {
        case TestWordFillingSameLanguage:
            question  = [NSString stringWithFormat:@"(%@) %@",wordType,[word getMeaning:@"English" bExample:NO]];
            [card displayQuestion:question ];
            break;
        case TestWordFillingUserLanguage:
            question  = [NSString stringWithFormat:@"(%@) %@",wordType,[word getMeaning:@"Vietnamese" bExample:NO]];
            [card displayQuestion:question ];
            break;
        case TestWordFillingWordListen:
            [card displayWordSpeaker:word.name];
            break;
        default:
            break;
    }
    answer = word.name;
}


-(UIView *) createNextQuestion
{
    curWordNo++;
    int randType = curTestType;
    while(randType == curTestType && TestTypeCount > 1)
    {
        randType = arc4random_uniform(TestTypeCount);
    }
    curTestType = randType;
    return viewTypeList[curTestType];
}
-(void) displayNextQuestion
{
    switch (curTestType) {
        case TestMultipleChoiceSameLanguage:
            [self displayMultipleChoiceCard];
            break;
        case TestMultipleChoiceUserLanguage:
            [self displayMultipleChoiceCard];
            break;
        case TestWordFillingSameLanguage:
            [self displayFillingWordCard];
            break;
        case TestWordFillingUserLanguage:
            [self displayFillingWordCard];
            break;
        case TestWordFillingWordListen:
            [self displayFillingWordCard];
            break;
        default:
            break;
    }
    
}
-(BOOL) checkAnswer:(NSString *) _answer
{
    BOOL isCorrect = [[answer lowercaseString] isEqualToString:[_answer lowercaseString]];
    switch (curTestType) {
        case TestMultipleChoiceSameLanguage:
        {
            CardMultipleChoiceView *card = [viewTypeList objectAtIndex:TestMultipleChoiceSameLanguage];
            [card displayCorrectChoice:answer wrongChoice:[_answer isEqualToString:answer]?@"":_answer];
            break;
        }
        case TestMultipleChoiceUserLanguage:
        {
            CardMultipleChoiceView *card = [viewTypeList objectAtIndex:TestMultipleChoiceUserLanguage];
            [card displayCorrectChoice:answer wrongChoice:[_answer isEqualToString:answer]?@"":_answer];
            break;
        }
        case TestWordFillingSameLanguage:
        {
            CardTypeAnswerView *card = [viewTypeList objectAtIndex:TestWordFillingSameLanguage];
            [card displayCorrectChoice:answer isCorrect:isCorrect];
            break;
        }
        case TestWordFillingUserLanguage:
        {
            CardTypeAnswerView *card = [viewTypeList objectAtIndex:TestWordFillingUserLanguage];
            [card displayCorrectChoice:answer isCorrect:isCorrect];
            break;
        }
        case TestWordFillingWordListen:
        {
            CardTypeAnswerView *card = [viewTypeList objectAtIndex:TestWordFillingUserLanguage];
            [card displayCorrectChoice:answer isCorrect:isCorrect];
            break;
        }

        default:
            break;
    }
    Word *word = wordList[curWordNo];
    if (isCorrect) {
        [delegate testMaker:self answerCorrectly:word];
    }
    else{
        [delegate testMaker:self answerWrongly:word];
    }
    return isCorrect;
}
-(BOOL) isTestFinished
{
    return curWordNo >= wordList.count -1;
}
-(int) getCurQuesNo
{
    return curWordNo;
}

@end
