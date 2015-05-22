//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordTestVC.h"

@interface WordTestVC () <ModelDelegate>

@end


@implementation WordTestVC{
    NSArray *wordList;
    int curWordNo;
    NSMutableArray * correctWordList;
    IBOutlet UIButton *nextBtn;
}

@synthesize wordCard = _wordCard;
@synthesize wordNoLb = _wordNoLb;
@synthesize curSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    _wordCard.delegate = self;
    _wordCard.view.bounds = _wordCard.bounds;
    
    curWordNo = 0;
    [self.setTitleLb setText:self.curSet.name];
    
    [self retrieveWords];
    [_wordCard clearDisplay];
    [self.loadingView startLoading];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)retrieveWords {
    [curSet setDelegate:self];
    [curSet findId:curSet.modelId];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) displayCurWord
{
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%lu",curWordNo+1,(unsigned long)wordList.count]];
    Word *word = wordList[curWordNo];
    NSString *question = [word getMeaning:@"English" bExample:NO];
    NSMutableArray *answerPool = [NSMutableArray new];
    [answerPool addObject:word.name];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    [answerPool addObject:[self getRandomWordNameDifferentFrom:answerPool]];
    answerPool = [self shuffleArray:answerPool];
    [_wordCard displayMultipleChoiceQuestion:question choice1:answerPool[0] choice2:answerPool[1] choice3:answerPool[2] choice4:answerPool[3]];
    
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

- (IBAction)next:(id)sender {

    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(BOOL) startMove:(CardInfoView *)wordCard :(BOOL) moveLeft
{
    return [super startMove:wordCard :moveLeft];
}
-(void) startEndMove:(CardInfoView *)wordCard :(BOOL) moveLeft :(int)startX
{
    [self displayCurWord];
    [super startEndMove:wordCard :moveLeft :startX];
}
-(void) endMove
{
    
}

#pragma mark - CardTestView Delegate
-(void) choiceSelect:(NSString *) choice
{
    Word *word = wordList[curWordNo];
    NSString *answer = word.name;
    if ([answer isEqual:choice]) {
        [correctWordList addObject:word];
        NSLog(@"Correct answer");
    }
    else
    {
        NSLog(@"Wrong answer");
    }
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }
    else
    {
        [_wordCard displayMessage:[NSString stringWithFormat:@"You have answer correctly %lu out of %lu", (unsigned long)correctWordList.count, (unsigned long)wordList.count]];
        [nextBtn setTitle:@"Finish" forState:UIControlStateNormal];
    }
}


#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    wordList = model.wordList;
    wordList = [[self shuffleArray:[wordList mutableCopy]] copy];
    [self displayCurWord];
    [self.loadingView endLoading];
    
    correctWordList = [NSMutableArray new];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [self.loadingView endLoading];
}

@end
