//
//  WordDisplayView.h
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface WordDisplayView : UIViewController

@property BOOL isInAnimation;

-(BOOL) startMove:(UIView *)wordCard :(BOOL) moveLeft;
-(BOOL) startMove:(UIView *)wordCard :(BOOL) moveLeft delay:(CGFloat) delayInSecond;
-(void) startEndMove:(UIView *)wordCard :(BOOL) moveLeft;
-(void) endMove;
-(BOOL) startFlip:(UIView *)wordCard;
-(void) startEndFlip:(UIView *)wordCard;
-(void) endFlip;

-(void) popButton:(UIButton *) button;
@end
/*
  basic function
 
 -(BOOL) startMove:(CardInfoView *)wordCard :(BOOL) moveLeft
 {
 return [super startMove:wordCard :moveLeft];
 }
 -(void) startEndMove:(CardInfoView *)wordCard :(BOOL) moveLeft :(int)startX
 {
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
 [super startEndFlip:wordCard];
 }
 -(void) endFlip
 {
 
 }
 -(void) cardIsTapped:(CardInfoView *)card
 {
 
 }
 */