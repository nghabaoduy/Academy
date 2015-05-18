//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordInfoVC.h"

@interface WordInfoVC () <ModelDelegate>

@end


@implementation WordInfoVC{
    NSArray *wordList;
    int curWordNo;
    BOOL isFront;
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
    isFront = YES;
    
    [self retrieveWords];
    [_wordCard clearDisplay];
    
    [self.loadingView startLoading];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
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
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%i",curWordNo+1,wordList.count]];
    Word *word = wordList[curWordNo];
    if (isFront) {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"English" bExample:YES]];
    }
    else
    {
        [_wordCard displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:@"Vietnamese" bExample:YES]];
    }
}
- (IBAction)next:(id)sender {
    isFront = YES;
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
        
    };
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
    NSLog(@"cardIsTapped");
    [self startFlip:_wordCard];
}

#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    wordList = model.wordList;
    [self displayCurWord];
    [self.loadingView endLoading];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [self.loadingView endLoading];
}

@end
