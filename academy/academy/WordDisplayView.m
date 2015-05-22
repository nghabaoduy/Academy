//
//  WordDisplayView.m
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordDisplayView.h"

@interface WordDisplayView ()

@end

@implementation WordDisplayView

@synthesize isInAnimation = _isInAnimation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    if (self.loadingView != nil) {
        return;
    }
    self.loadingView = [[LoadingUIView alloc] init];
    [self.view addSubview:self.loadingView];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.loadingView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) startMove:(UIView *)wordCard :(BOOL) moveLeft
{
    if (_isInAnimation) {
        return NO;
    }
    _isInAnimation = YES;
    int startX = wordCard.frame.origin.x;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         wordCard.frame = CGRectMake(self.view.frame.size.width* (moveLeft?-1:1), wordCard.frame.origin.y, wordCard.frame.size.width, wordCard.frame.size.height);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             [self startEndMove:wordCard:moveLeft:startX];
                         }
                     }];
    return YES;
}
-(void) startEndMove:(UIView *)wordCard :(BOOL) moveLeft :(int)startX
{
    wordCard.frame = CGRectMake(self.view.frame.size.width* (moveLeft?1:-1), wordCard.frame.origin.y, wordCard.frame.size.width, wordCard.frame.size.height);
    [UIView animateWithDuration:0.2 delay:0.0 options:    UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         wordCard.frame = CGRectMake(startX, wordCard.frame.origin.y, wordCard.frame.size.width, wordCard.frame.size.height);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             _isInAnimation = NO;
                             [self endMove];
                         }
                     }];
}
-(void) endMove
{
    
}
-(BOOL) startFlip:(UIView *)wordCard
{
    if (_isInAnimation) {
        return NO;
    }
    _isInAnimation = YES;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         wordCard.transform = CGAffineTransformMakeScale(0.01, 1);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             [self startEndFlip:wordCard];
                         }
                     }];
    return YES;
}
-(void) startEndFlip:(UIView *)wordCard
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         wordCard.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             _isInAnimation = NO;
                             [self endFlip];
                         }
                     }];
}
-(void) endFlip
{
    
}

@end
