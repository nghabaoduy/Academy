//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordTestVC.h"

#import "SoundEngine.h"

@interface WordTestVC () <ModelDelegate>

@end


@implementation WordTestVC{
    
    
    NSMutableArray * correctWordList;
    IBOutlet UIButton *nextBtn;
    TestMaker *testMaker;
    
    UIView *curCard;
    UIView *nextCard;
    
    BOOL hasAnswered;
}

@synthesize cardMultipleChoice = _cardMultipleChoice;
@synthesize cardTypeAnswer = _cardTypeAnswer;
@synthesize wordNoLb = _wordNoLb;
@synthesize curSet, wordList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    _cardMultipleChoice.delegate = self;
    _cardMultipleChoice.view.bounds = _cardMultipleChoice.bounds;
    [_cardMultipleChoice clearDisplay];
    
    _cardTypeAnswer.delegate = self;
    _cardTypeAnswer.view.bounds = _cardTypeAnswer.bounds;
    [_cardTypeAnswer clearDisplay];
    

    [self.setTitleLb setText:self.curSet.name];
    
    if (!wordList) {
        [self retrieveWords];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        [self startTest];
    }
}

-(void) startTest
{
    hasAnswered = NO;
    testMaker =[[TestMaker alloc] initWithSetAndWordList:curSet wordList:wordList];
    [self registerTestMakerCardView];
    curCard = [testMaker createNextQuestion];
    [testMaker displayNextQuestion];
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%lu",[testMaker getCurQuesNo]+1,(unsigned long)wordList.count]];
    correctWordList = [NSMutableArray new];
    [self refreshCardHiddenState];
}
-(void) registerTestMakerCardView
{
    [testMaker registerCardView:_cardMultipleChoice];
    [testMaker registerCardView:_cardTypeAnswer];
}

-(void) refreshCardHiddenState
{
    if (curCard && nextCard && curCard != nextCard) {
        curCard = nextCard;
        nextCard = nil;
    }
    
    _cardMultipleChoice.hidden = YES;
    _cardTypeAnswer.hidden = YES;
    curCard.hidden = NO;
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
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.wordInfoView) {
            [self.wordInfoView dismissViewControllerAnimated:YES completion:nil];
            self.wordInfoView = nil;
        }
    }];
}

- (IBAction)next:(id)sender {
    if (![testMaker isTestFinished]) {
        NSLog(@"curcard = %@",curCard);
        if ([self startMove:curCard:YES]) {
            nextCard = [testMaker createNextQuestion];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.wordInfoView) {
                [self.wordInfoView dismissViewControllerAnimated:YES completion:nil];
                self.wordInfoView = nil;
            }
        }];
    }
}
-(void) startEndMove:(UIView *)wordCard :(BOOL) moveLeft :(int)startX
{
    [testMaker displayNextQuestion];
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%lu",[testMaker getCurQuesNo]+1,(unsigned long)wordList.count]];
    if (nextCard != curCard) {
        [super startEndMove:nextCard :moveLeft :startX];
    }
    else
    {
        [super startEndMove:curCard :moveLeft :startX];
    }
    
    
    [self refreshCardHiddenState];
    
}
-(void) endMove
{
    hasAnswered = NO;
    [nextBtn setEnabled:YES];
}
-(void) checkAnswer:(NSString *) answer
{
    [nextBtn setEnabled:NO];
    if (hasAnswered) {
        return;
    }
    hasAnswered = YES;
    if ([testMaker checkAnswer:answer]) {
        NSLog(@"Correct answer");
        [[SoundEngine getInstance] playSound:@"Correct.mp3"];
    }
    else
    {
        NSLog(@"Wrong answer");
    }
    if (![testMaker isTestFinished]) {
        if ([self startMove:curCard:YES delay:1.5]) {
            nextCard = [testMaker createNextQuestion];
        }
    }
    else
    {
        [nextBtn setTitle:@"Finish" forState:UIControlStateNormal];
    }
}

#pragma mark - CardMultipleChoiceView Delegate
-(void) CardMultipleChoiceView:(CardMultipleChoiceView *)cardView choiceSelect:(NSString *) choice
{
    [self checkAnswer:choice];
}
#pragma mark - CardMultipleChoiceView Delegate
-(void)CardTypeAnswerView:(CardTypeAnswerView *)cardView checkAnswer:(NSString *)answer
{
    [self checkAnswer:answer];
}

#pragma mark - TestMaker Delegate
-(void)testMaker:(TestMaker *)_testMaker answerCorrectly:(Word *)_word
{
    [correctWordList addObject:_word];
}
-(void)testMaker:(TestMaker *)_testMaker answerWrongly:(Word *)_word
{
    
}

#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    wordList = model.wordList;
    wordList = [[self shuffleArray:[wordList mutableCopy]] copy];
    [self startTest];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
