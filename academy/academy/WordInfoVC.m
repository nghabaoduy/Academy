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
#import "AlertMascotView.h"
#import "SoundEngine.h"

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
    
    NSString *errorMessage;
}

@synthesize wordCard = _wordCard;
@synthesize wordNoLb = _wordNoLb;
@synthesize setTitleLb = _setTitleLb;
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
    _wordNoLb.text = @"";
    _setTitleLb.text = @"";
    
    NSLog(@"curset.wordList = %@",[curSet getDictionaryFromObject]);
    
    self.language = curSet.language;
    
    
    knownWords = [NSMutableArray new];
    [self resetView];
    [self performSelector:@selector(retrieveWords) withObject:self afterDelay:0.5];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    NSLog(@"displayCurWord - %@",word);
    //Check Session
    if (isWordCheckSession) {
        [_wordCard displayCenterWord:word.name message:@"Bạn có biết từ này không?"];
        return;
    }
    
    if (isFront) {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:self.language bExample:YES] wordSubDict:[word getWordSubDict:self.language]];
    }
    else
    {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"Vietnamese" bExample:YES] wordSubDict:[word getWordSubDict:self.language]];
        //[_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"Vietnamese" bExample:YES]];
    }
    
    prevBtn.hidden = curWordNo == 0;
    
    
}
// PREV - NEXT
- (IBAction)next:(id)sender {
    isFront = YES;
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
    }
    else
    {
        [self alertGoToTest];
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
    AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
    [cartoonView.messageLb setText:@"Bắt đầu học từ mới nào!"];
    [alertView setContainerView:cartoonView];

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Okie", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [self displayCurWord];
        [alertView close];

        Word *word = wordList[curWordNo];
        [[SoundEngine getInstance] readWord:word.name language:self.language];

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
    AlertMascotView *cartoonView = [[AlertMascotView alloc] init];
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
                //[self dismissViewControllerAnimated:YES completion:nil];
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
    [nextBtn setEnabled:NO];
    [prevBtn setEnabled:NO];
    [knowBtn setEnabled:NO];
    [dunnoBtn setEnabled:NO];
    return [super startMove:wordCard :moveLeft];
}
-(void) startEndMove:(CardInfoView *)wordCard :(BOOL) moveLeft :(int)startX
{
    [self displayCurWord];
    [super startEndMove:wordCard :moveLeft :startX];
}
-(void) endMove
{
    [nextBtn setEnabled:YES];
    [prevBtn setEnabled:YES];
    [knowBtn setEnabled:YES];
    [dunnoBtn setEnabled:YES];
    if (!isWordCheckSession) {
        Word *word = wordList[curWordNo];
        [[SoundEngine getInstance] readWord:word.name language:self.language];

        if (curWordNo>= wordList.count -1) {
            [nextBtn setBackgroundImage:[UIImage imageNamed:@"medium-green-btn"] forState:UIControlStateNormal];
            [nextBtn setTitle:@"Test" forState:UIControlStateNormal];
        }
        if (curWordNo == wordList.count -2) {
            [nextBtn setBackgroundImage:[UIImage imageNamed:@"medium-blue-btn"] forState:UIControlStateNormal];
            [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
        }
    }
}
-(BOOL) startFlip:(CardInfoView *)wordCard
{
    [nextBtn setEnabled:NO];
    [prevBtn setEnabled:NO];
    [knowBtn setEnabled:NO];
    [dunnoBtn setEnabled:NO];
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
    [nextBtn setEnabled:YES];
    [prevBtn setEnabled:YES];
    [knowBtn setEnabled:YES];
    [dunnoBtn setEnabled:YES];
    if (!isWordCheckSession) {
        Word *word = wordList[curWordNo];
        [[SoundEngine getInstance] readWord:word.name language:self.language];
    }
}
#pragma mark - CardInfo delegate
-(void) cardIsTapped:(CardInfoView *)card
{
    if (!isWordCheckSession) {
        //NSLog(@"cardIsTapped");
        [self startFlip:_wordCard];
    }
}
- (NSString *)CardInfoViewGetLanguage
{
    return self.language;
}


#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Model.wordList = %@",model.wordList);
    wordList = model.wordList;
    originalWordList = [wordList copy];
    [self displayCurWord];
    if (!isWordCheckSession) {
        Word *word = wordList[curWordNo];
        [[SoundEngine getInstance] readWord:word.name language:self.language];
    }
    
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    
    NSLog(@"ErrorMessage[%i] = %@",[statusCode intValue],error);
    errorMessage = error;
    [self performSelector:@selector(displayError) withObject:self afterDelay:0.5];
}
-(void) displayError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    
    
}

@end
