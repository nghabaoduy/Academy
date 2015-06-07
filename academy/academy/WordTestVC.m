//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordTestVC.h"
#import "DDHTimerControl.h"
#import "CustomIOSAlertView.h"
#import "TestRankAnimView.h"
#import "SoundEngine.h"
#import "AlertMascotView.h"
#import "TestSettingView.h"

@interface WordTestVC () <ModelDelegate>

@end


@implementation WordTestVC{
    LSet *curSet;
    
    NSMutableArray * correctWordList;
    IBOutlet UIButton *nextBtn;
    TestMaker *testMaker;
    
    UIView *curCard;
    UIView *nextCard;
    
    BOOL hasAnswered;
    DDHTimerControl *_timerControl;
    NSDate *endDate;
    
    BOOL isTestFinished;
    BOOL isTFUp;
    
    IBOutlet UIButton *testSettingBtn;
    TestPickType curPickType;
    
    NSTimer * testTimer;
    
    BOOL isFinalTest;
    int finalTestTotalQuestion;
}

@synthesize cardMultipleChoice = _cardMultipleChoice;
@synthesize cardTypeAnswer = _cardTypeAnswer;
@synthesize wordNoLb = _wordNoLb;
@synthesize setTitleLb = _setTitleLb;
@synthesize curSet, curPack, wordList;

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
        if (curPack) {
            isFinalTest = YES;
            finalTestTotalQuestion = 20;
        }
        [self performSelector:@selector(displayAlertTestPick) withObject:self afterDelay:0.5];
    }
    _wordNoLb.text = @"";
}

- (IBAction)close:(id)sender {
    [self dismissSelf];
    
}
-(void) dismissSelf
{
    if (testTimer) {
        [testTimer invalidate];
        testTimer = nil;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.wordInfoView) {
            
            [self.wordInfoView dismissViewControllerAnimated:YES completion:nil];
            self.wordInfoView = nil;
        }
    }];
}

- (void) addTimer
{
    if (_timerControl != nil) {
        testTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
        endDate = [NSDate dateWithTimeIntervalSinceNow:[testMaker getTestWordQuantity] * 6];
        return;
    }
    _timerControl = [DDHTimerControl timerControlWithType:DDHTimerTypeSolid];
    _timerControl.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl.color = [UIColor orangeColor];
    _timerControl.highlightColor = [UIColor redColor];
    _timerControl.maxValue = [testMaker getTestWordQuantity] * 6;
    _timerControl.titleLabel.text = @"sec";
    _timerControl.userInteractionEnabled = NO;
    _timerControl.frame = CGRectMake(self.view.frame.size.width - 70 - 5, 30, 70, 70);
    [self.view addSubview:_timerControl];
    if (testTimer) {
        [testTimer invalidate];
        testTimer = nil;
    }
    testTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    endDate = [NSDate dateWithTimeIntervalSinceNow:[testMaker getTestWordQuantity] * 6];
}
- (void)changeTimer:(NSTimer*)timer {
    if (isTestFinished) {
        return;
    }
    NSTimeInterval timeInterval = [endDate timeIntervalSinceNow];
    _timerControl.minutesOrSeconds = ((NSInteger)timeInterval);
    if (timeInterval <=-1) {
        [self finishTest];
    }
    
}
-(void) displayAlertTestPick
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    AlertTestModePickView *modePickView = [[AlertTestModePickView alloc] init];
    modePickView.alertView = alertView;
    modePickView.delegate = self;
    if (!isFinalTest) {
        [modePickView setTestTimeText:(int)(wordList.count * 6)];
    }
    else
    {
        [modePickView setTestTimeText:(int)(finalTestTotalQuestion * 6)];
    }
    
    [alertView setContainerView:modePickView];

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects: nil]];
    [alertView setUseMotionEffects:true];
    [alertView show];

}
-(void) restartTest
{
    [self startTest];
}
-(void) startTest
{
    isTestFinished = NO;
    hasAnswered = NO;
    if (!testMaker) {
        testMaker =[[TestMaker alloc] initWithWordList:wordList];
    }
    else{
        [testMaker resetTest];
    }
    if (isFinalTest && curPickType == TestPickTimer) {
        testMaker.testWordQuantity = finalTestTotalQuestion;
        [testMaker resetTest];
    }
    testMaker.delegate = self;
    
    [self registerTestMakerCardView];
    curCard = [testMaker createNextQuestion];
    [testMaker displayNextQuestion];
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%i",[testMaker getCurQuesNo]+1,[testMaker getTestWordQuantity]]];
    correctWordList = [NSMutableArray new];
    [self refreshCardHiddenState];
    [nextBtn setEnabled:YES];
}
-(void) finishTest
{
    isTestFinished = YES;
    if (testTimer) {
        [testTimer invalidate];
        testTimer = nil;
    }
    
    [_cardTypeAnswer dismissKeyboard];
    //ranking
    NSNumber * grade;
    if (correctWordList.count >= [testMaker getTestWordQuantity]) {
        grade = [NSNumber numberWithInt:3];
    } else
    if (correctWordList.count >= [testMaker getTestWordQuantity]*70/100) {
        grade = [NSNumber numberWithInt:2];
    } else
    if (correctWordList.count >= [testMaker getTestWordQuantity]*50/100) {
            grade = [NSNumber numberWithInt:1];
    } else
    {
        grade = [NSNumber numberWithInt:0];
    }
    
    if (!isFinalTest) {
        curSet.grade = grade;
        SetScore * newsScore = [SetScore new];
        newsScore.delegate = self;
        newsScore.score = curSet.grade;
        newsScore.set_id = curSet.modelId;
        [newsScore createModel];
    }
    
    [self performSelector:@selector(displayFinishTestAlert) withObject:self afterDelay:0.5];

    
    
}
-(void) displayFinishTestAlert
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    if (curPickType == TestPickNormal) {
        
        AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
        [cartoonView.messageLb setText:[NSString stringWithFormat:@"Bạn trả lời đúng %lu/%i câu hỏi.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]]];
        [alertView setContainerView:cartoonView];
        [[SoundEngine getInstance] playSound:@"Finish.mp3"];
        
    }
    else
    {
        if ([curSet.grade intValue] == 0) {
            
            AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
            [cartoonView.messageLb setText:[NSString stringWithFormat:@"Tiếc quá, bạn chỉ trả lời đúng %lu/%i câu thôi, cố lên nhé.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]]];
            [cartoonView.mascotImg setImage:[UIImage imageNamed:@"giraffe_sad.png"]];
            [alertView setContainerView:cartoonView];
            [[SoundEngine getInstance] playSound:@"Fail.mp3"];
            
        }
        else
        {
           
            TestRankAnimView *rankView = [[TestRankAnimView alloc] init];
            NSString *message = [NSString stringWithFormat:@"Chúc mừng, bạn đã hoàn thành bài kiểm tra với %lu/%i câu trả lời đúng.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]];
            [rankView setMessage:message];
            [rankView setLSet:curSet];
            [alertView setContainerView:rankView];
             [[SoundEngine getInstance] playSound:@"Win.mp3"];
        }
    }
    
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Thoát", @"Làm lại", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        switch (buttonIndex) {
            case 0:
                [self dismissSelf];
                break;
            case 1:
                [self displayAlertTestPick];
            default:
                break;
        }
        [alertView close];
        
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)retrieveWords {
    [curSet setDelegate:self];
    [curSet findId:curSet.modelId];
}



- (IBAction)next:(id)sender {
    if (![testMaker isLastQuestion]) {
        NSLog(@"curcard = %@",curCard);
        if ([self startMove:curCard:YES]) {
            nextCard = [testMaker createNextQuestion];
        }
    }
    else
    {
        [self finishTest];
    }
}
-(void) startEndMove:(UIView *)wordCard :(BOOL) moveLeft :(int)startX
{
    [testMaker displayNextQuestion];
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%i",[testMaker getCurQuesNo]+1,[testMaker getTestWordQuantity]]];
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
        [[SoundEngine getInstance] playSound:@"Wrong.mp3"];
    }
    if (![testMaker isLastQuestion]) {
        if ([self startMove:curCard:YES delay:curPickType == TestPickNormal?1.5:0.5]) {
            nextCard = [testMaker createNextQuestion];
        }
    }
}

- (IBAction)goTestSetting:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TestSettingView *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"testSettingView"];
    destination.parentView = self;
    destination.testMaker = testMaker;
    UINavigationController *desNavController = [[UINavigationController alloc] initWithRootViewController:destination];
    [self presentViewController:desNavController animated:YES completion:nil];
}


#pragma mark - AlertTestModePick Delegate
-(void)AlertTestModePickView:(AlertTestModePickView *)modePickView modePicked:(TestPickType)testPickType
{
    curPickType = testPickType;
    [modePickView.alertView close];
    switch (testPickType) {
        case TestPickNormal:
            [self startTest];
            testSettingBtn.hidden = NO;
            break;
        case TestPickTimer:
        {
            [self startTest];
            testSettingBtn.hidden = YES;
            [testMaker setAllowAnswerBack:YES];
            [self addTimer];
        }
            break;
        default:
            break;
    }
}

#pragma mark - CardMultipleChoiceView Delegate
-(void) CardMultipleChoiceView:(CardMultipleChoiceView *)cardView choiceSelect:(NSString *) choice
{
    [self checkAnswer:choice];
}
#pragma mark - CardTypeAnswerView Delegate
-(void)CardTypeAnswerView:(CardTypeAnswerView *)cardView checkAnswer:(NSString *)answer
{
    [self checkAnswer:answer];
}
-(void)CardTypeAnswerView:(CardTypeAnswerView *)cardView textfieldStartEditing:(UITextField *)textfield
{
    int tfBottomY = cardView.frame.origin.y + textfield.frame.origin.y + textfield.frame.size.height;
    [self animateTextField:tfBottomY up:YES];
}
-(void)CardTypeAnswerView:(CardTypeAnswerView *)cardView textfieldEndEditing:(UITextField *)textfield
{
    int tfBottomY = cardView.frame.origin.y + textfield.frame.origin.y + textfield.frame.size.height;
    [self animateTextField:tfBottomY up:NO];
}
- (void) animateTextField: (int)tfBottomY up: (BOOL) up
{
    if (isTFUp == up) {
        return;
    }
    isTFUp = up;
    float keyboardHeight = 260.0f;
    
    NSLog(@"tfBottomY = %i vs %f",tfBottomY,self.view.frame.size.height - keyboardHeight);
    
    if ( tfBottomY > self.view.frame.size.height - keyboardHeight) {
        const int movementDistance = 100; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        if (up)
            self.view.frame = CGRectMake(0, movement, self.view.frame.size.width, self.view.frame.size.height);
        else
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}
#pragma mark - TestMaker Delegate
-(void)testMaker:(TestMaker *)_testMaker answerCorrectly:(Word *)_word testFinished:(BOOL) finished
{
    [correctWordList addObject:_word];
    finished?[self finishTest]:nil;
}
-(void)testMaker:(TestMaker *)_testMaker answerWrongly:(Word *)_word testFinished:(BOOL) finished
{
    finished?[self finishTest]:nil;
}
#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    curSet = model;
    
    wordList = model.wordList;
    [self displayAlertTestPick];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)createModelSuccessful:(AModel *)model {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
