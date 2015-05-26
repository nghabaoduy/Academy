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

@implementation WordDisplayView{
    UIView *curCard;
    BOOL direction;
}

@synthesize isInAnimation = _isInAnimation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) startMove:(UIView *)wordCard :(BOOL) moveLeft
{
    return [self startMove:wordCard :moveLeft delay:0];
}
-(BOOL) startMove:(UIView *)wordCard :(BOOL) moveLeft delay:(CGFloat) delayInSecond
{
    if (_isInAnimation) {
        return NO;
    }
    _isInAnimation = YES;
    curCard = wordCard;
    direction = moveLeft;
    [self performSelector:@selector(performMove) withObject:self afterDelay:delayInSecond];
    return YES;
}
-(void) performMove
{
    int startX = curCard.frame.origin.x;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         curCard.frame = CGRectMake(self.view.frame.size.width* (direction?-1:1), curCard.frame.origin.y, curCard.frame.size.width, curCard.frame.size.height);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             [self startEndMove:curCard:direction:startX];
                         }
                     }];
   
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
