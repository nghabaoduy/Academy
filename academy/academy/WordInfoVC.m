//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordInfoVC.h"
#import "WordTestVC.h"
#import "CustomIOSAlertView.h"
#import "AlertCartoonView.h"

@interface WordInfoVC () <ModelDelegate>

@end


@implementation WordInfoVC{
    NSArray *originalWordList;
    NSArray *wordList;
    NSMutableArray *knownWords;
    int curWordNo;
    BOOL isFront;
    
    IBOutlet UIButton *prevBtn;
    IBOutlet UIButton *nextBtn;
    IBOutlet UIButton *knowBtn;
    IBOutlet UIButton *dunnoBtn;
}

@synthesize wordCard = _wordCard;
@synthesize wordNoLb = _wordNoLb;
@synthesize curSet,isWordCheckSession;
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
    
    
    [self retrieveWords];
    [self.loadingView startLoading];
    
    knownWords = [NSMutableArray new];
    [self resetView];
}

-(void) resetView
{
    [_wordCard clearDisplay];
    
    curWordNo = 0;
    isFront = YES;
    [self.setTitleLb setText:self.curSet.name];
    
    [prevBtn setHidden:YES];
    [nextBtn setHidden:YES];
    [knowBtn setHidden:YES];
    [dunnoBtn setHidden:YES];
    
    if (!isWordCheckSession) {
        [prevBtn setHidden:NO];
        [nextBtn setHidden:NO];
    }
    else{
        [knowBtn setHidden:NO];
        [dunnoBtn setHidden:NO];
    }
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
    
    //Check Session
    if (isWordCheckSession) {
        [_wordCard displayCenterWord:word.name message:@"Bạn có biết từ này không?"];
        return;
    }
    

    if (isFront) {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"English" bExample:YES]];
    }
    else
    {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"Vietnamese" bExample:YES]];
    }
    
    prevBtn.hidden = curWordNo == 0;
    nextBtn.hidden = curWordNo >= wordList.count -1;
    
}
// PREV - NEXT
- (IBAction)next:(id)sender {
    isFront = YES;
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }
}
- (IBAction)prev:(id)sender
{
    isFront = YES;
    if (curWordNo>0) {
        if ([self startMove:_wordCard:NO])
        {
            curWordNo--;
        }
    }
}


// KNOW - DUNNO
- (IBAction)know:(id)sender {
    if (![knownWords containsObject:wordList[curWordNo]]) {
        [knownWords addObject:wordList[curWordNo]];
    }

    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }else{
        [self startWordInfoSession];
    }
}
- (IBAction)dunno:(id)sender
{
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }else{
        [self startWordInfoSession];
    }
}

-(void) startWordInfoSession
{
    if (knownWords.count >= wordList.count) {
        [self alertGoToTest];
        return;
    }
    
    if (knownWords.count > 0) {
        NSMutableArray * sortedWordArray = [wordList mutableCopy];
        for (Word *word in knownWords) {
            [sortedWordArray removeObject:word];
        }
        wordList = [sortedWordArray copy];
    }
    
    isWordCheckSession = NO;
    [self resetView];
    [self alertChangeToWordInfoSession];
 
}

-(void) alertChangeToWordInfoSession
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    AlertCartoonView *cartoonView = [[AlertCartoonView alloc] init];
    [cartoonView.messageLb setText:@"Bắt đầu học từ mới nào!"];
    [alertView setContainerView:cartoonView];

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Okie", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [self displayCurWord];
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}
// GO TO TEST
-(void) alertGoToTest
{
    NSLog(@"alertGoToTest called");
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    AlertCartoonView *cartoonView = [[AlertCartoonView alloc] init];
    [cartoonView.messageLb setText:@"Làm bài test ngay nhé?"];
    [alertView setContainerView:cartoonView];
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Okie",@"Chút nữa", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 0) {
            [self goToTestView];
        }
        else
        {
            if (knownWords.count >= wordList.count) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

-(void) goToTestView
{
    WordTestVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
    view.curSet = self.curSet;
    view.wordList = originalWordList;
    view.wordInfoView = self;
    [self presentViewController:view animated:YES completion:nil];
}

// CARD MOVE - FLIP

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
-(BOOL) startFlip:(CardInfoView *)wordCard
{
    return [super startFlip:wordCard];
}
-(void) startEndFlip:(CardInfoView *)wordCard
{
    isFront = !isFront;
    [self displayCurWord];
    [super startEndFlip:wordCard];
}
-(void) endFlip
{
    
}
-(void) cardIsTapped:(CardInfoView *)card
{
    if (!isWordCheckSession) {
        NSLog(@"cardIsTapped");
        [self startFlip:_wordCard];
    }
}

#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    wordList = model.wordList;
    originalWordList = [wordList copy];
    [self displayCurWord];
    [self.loadingView endLoading];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [self.loadingView endLoading];
}

@end
