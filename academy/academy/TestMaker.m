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
    
    NSMutableArray *wordList;
    TestType curTestType;
    NSMutableArray *viewTypeList;
    int curWordNo;
    NSString *answer;
    BOOL allowAnswerBack;
    BOOL hasFinishedRound1;
    
    NSMutableArray *answeredQuestion;
}
@synthesize delegate;
- (id)initWithSetAndWordList:(LSet *)_set wordList:(NSArray *) _wordList {
    self = [super init];
    if (self) {
        _fullWordList = _wordList;
        curSet = _set;
        _userPickedTestType = TestTypeCount;
        _testWordQuantity = _wordList.count;
        [self resetTest];
    }
    return self;
}
-(void) resetTest
{
    wordList = [NSMutableArray new];
    NSMutableArray * shuffledWordList = [self shuffleArray:[_fullWordList mutableCopy]];
    for (int i = 0; i<MIN(shuffledWordList.count, _testWordQuantity); i++) {
        [wordList addObject:shuffledWordList[i]];
    }

    viewTypeList = [[NSMutableArray alloc] initWithCapacity:TestTypeCount];
    curWordNo = -1;
    curTestType = _userPickedTestType != TestTypeCount? _userPickedTestType : arc4random_uniform(TestTypeCount);
    answeredQuestion = [NSMutableArray new];
    hasFinishedRound1 = NO;
}
-(int) getTestWordQuantity
{
    return wordList.count;
}
-(void) setAllowAnswerBack:(BOOL) allow
{
    allowAnswerBack = allow;
}
-(void) registerCardView:(UIView *) view
{

    if ([view class] == [CardMultipleChoiceView class]) {
        viewTypeList[TestMultipleChoiceSameLanguage] = view;
        viewTypeList[TestMultipleChoiceUserLanguage] = view;
        viewTypeList[TestMultipleChoiceExampleBlank] = view;
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
        case TestMultipleChoiceExampleBlank:
            question = [word getExample:@"English"];
            question = [question stringByReplacingOccurrencesOfString:word.name withString:@"__________"];
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
    curWordNo = [self getNextQuestionIndex];
    NSLog(@"curWordNo = %i",curWordNo);
    
    if (_userPickedTestType != TestTypeCount) {
        return viewTypeList[_userPickedTestType];
    }
    
    int randType = curTestType;
    while(randType == curTestType || ![self questionTypeIsValid:randType])
    {
        randType = arc4random_uniform(TestTypeCount);
    }
    curTestType = randType;
    return viewTypeList[curTestType];
}
-(BOOL) questionTypeIsValid: (TestType) testT
{
    if (testT == TestTypeCount) {
        return NO;
    }
    int minCharacters = 10;
    int minWordsInSentence = 6;
    Word *word = wordList[curWordNo];
    switch (testT) {
        case TestMultipleChoiceExampleBlank:
        {
            NSString *example = [word getExample:@"English"];
            if (example.length < minCharacters) {
                return NO;
            }
            if ([example componentsSeparatedByString:@" "].count > minWordsInSentence) {
                return NO;
            }
        }
        break;
            
        default:
            break;
    }

    return YES;
}
-(int) getNextQuestionIndex
{
    if ([self isLastQuestion]) {
        return -1;
    }
    if (!allowAnswerBack) {
        return curWordNo+1;
    }
    else
    {
        if (curWordNo >= (int)(wordList.count -1) || hasFinishedRound1) {
            hasFinishedRound1 = YES;
            for (int i = curWordNo; i< wordList.count; i++) {
                Word *word = wordList[i];
                if (![answeredQuestion containsObject:word] && word != wordList[curWordNo]) {
                    return i;
                }
            }
            for (int i = 0; i< curWordNo; i++) {
                Word *word = wordList[i];
                if (![answeredQuestion containsObject:word] && word != wordList[curWordNo]) {
                    return i;
                }
            }
        }
        else
        {
            return curWordNo+1;
        }
    }
    return curWordNo;
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
        case TestMultipleChoiceExampleBlank:
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
    [answeredQuestion addObject:wordList[curWordNo]];
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
        case TestMultipleChoiceExampleBlank:
        {
            CardMultipleChoiceView *card = [viewTypeList objectAtIndex:TestMultipleChoiceExampleBlank];
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
        [delegate testMaker:self answerCorrectly:word testFinished:[self isLastQuestion]];
    }
    else{
        [delegate testMaker:self answerWrongly:word testFinished:[self isLastQuestion]];
    }
    
    return isCorrect;
}
-(BOOL) isLastQuestion
{
    if (!allowAnswerBack) {
        return (curWordNo >= (int)(wordList.count -1));
    }
    return answeredQuestion.count >= wordList.count;
    
}
-(int) getCurQuesNo
{
    return curWordNo;
}

+ (NSString *) getTestTypeName:(TestType) testT
{
    switch (testT) {
        case TestMultipleChoiceExampleBlank:
            return @"Trắc nghiệm điền chỗ trống";
        case TestMultipleChoiceSameLanguage:
            return @"Trắc nghiệm dịch câu";
        case TestMultipleChoiceUserLanguage:
            return @"Trắc nghiệm dịch nghĩa";
        case TestWordFillingSameLanguage:
            return @"Điền từ dịch câu";
        case TestWordFillingUserLanguage:
            return @"Điền từ dịch nghĩa";
        case TestWordFillingWordListen:
            return @"Nghe từ điền chữ";
        case TestTypeCount:
            return @"Tất cả";
        default:
            return @"";
    }
}

@end
