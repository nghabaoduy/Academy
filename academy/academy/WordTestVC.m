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
    DDHTimerControl *_timerControl3;
    NSDate *endDate;
    
    BOOL isTestFinished;
    BOOL isTFUp;
    
    IBOutlet UIButton *testSettingBtn;
    TestPickType curPickType;
}

@synthesize cardMultipleChoice = _cardMultipleChoice;
@synthesize cardTypeAnswer = _cardTypeAnswer;
@synthesize wordNoLb = _wordNoLb;
@synthesize setTitleLb = _setTitleLb;
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
        [self performSelector:@selector(displayAlertTestPick) withObject:self afterDelay:0.5];
    }
    _wordNoLb.text = @"";
}

- (void) addTimer
{
    if (_timerControl3 != nil) {
        endDate = [NSDate dateWithTimeIntervalSinceNow:[testMaker getTestWordQuantity] * 6];
        return;
    }
    _timerControl3 = [DDHTimerControl timerControlWithType:DDHTimerTypeSolid];
    _timerControl3.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl3.color = [UIColor orangeColor];
    _timerControl3.highlightColor = [UIColor redColor];
    _timerControl3.maxValue = [testMaker getTestWordQuantity] * 6;
    _timerControl3.titleLabel.text = @"sec";
    _timerControl3.userInteractionEnabled = NO;
    _timerControl3.frame = CGRectMake(self.view.frame.size.width - 70 - 5, 30, 70, 70);
    [self.view addSubview:_timerControl3];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    endDate = [NSDate dateWithTimeIntervalSinceNow:[testMaker getTestWordQuantity] * 6];
}
- (void)changeTimer:(NSTimer*)timer {
    if (isTestFinished) {
        return;
    }
    NSTimeInterval timeInterval = [endDate timeIntervalSinceNow];
    _timerControl3.minutesOrSeconds = ((NSInteger)timeInterval);
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
    [modePickView setTestTimeText:([testMaker getTestWordQuantity] * 6)];
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
        testMaker =[[TestMaker alloc] initWithSetAndWordList:curSet wordList:wordList];
    }
    else{
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
    [_cardTypeAnswer dismissKeyboard];
    //ranking
    if (correctWordList.count >= [testMaker getTestWordQuantity]) {
        curSet.grade = [NSNumber numberWithInt:3];
    } else
    if (correctWordList.count >= [testMaker getTestWordQuantity]*70/100) {
        curSet.grade = [NSNumber numberWithInt:2];
    } else
    if (correctWordList.count >= [testMaker getTestWordQuantity]*50/100) {
            curSet.grade = [NSNumber numberWithInt:1];
    } else
    {
        curSet.grade = [NSNumber numberWithInt:0];
    }
    
    SetScore * newsScore = [SetScore new];
    newsScore.delegate = self;
    newsScore.score = curSet.grade;
    newsScore.set_id = curSet.modelId;
    [newsScore createModel];
    [self displayFinishTestAlert];
    
    
}
-(void) displayFinishTestAlert
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    if (curPickType == TestPickNormal) {
        AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
        [cartoonView.messageLb setText:[NSString stringWithFormat:@"Bạn trả lời đúng %lu/%i câu hỏi.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]]];
        [alertView setContainerView:cartoonView];
    }
    else
    {
        if ([curSet.grade intValue] == 0) {
            AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
            [cartoonView.messageLb setText:[NSString stringWithFormat:@"Tiếc quá, bạn chỉ trả lời đúng %lu/%i câu thôi, cố lên nhé.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]]];
            [cartoonView.mascotImg setImage:[UIImage imageNamed:@"giraffe_sad.png"]];
            [alertView setContainerView:cartoonView];
            
        }
        else
        {
            TestRankAnimView *rankView = [[TestRankAnimView alloc] init];
            NSString *message = [NSString stringWithFormat:@"Chúc mừng, bạn đã hoàn thành bài kiểm tra với %lu/%i câu trả lời đúng.",(unsigned long)correctWordList.count, [testMaker getTestWordQuantity]];
            [rankView setMessage:message];
            [rankView setLSet:curSet];
            [alertView setContainerView:rankView];
        }
    }
    
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Thoát", @"Làm lại", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        switch (buttonIndex) {
            case 0:
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.wordInfoView) {
                        [self.wordInfoView dismissViewControllerAnimated:YES completion:nil];
                        self.wordInfoView = nil;
                    }
                }];
            }
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

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.wordInfoView) {
            [self.wordInfoView dismissViewControllerAnimated:YES completion:nil];
            self.wordInfoView = nil;
        }
    }];
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
