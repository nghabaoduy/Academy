//
//  CardParentVC.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoView.h"

@interface CardParentVC : UIViewController

@property BOOL isInAnimation;

-(BOOL) startMove:(CardInfoView *)wordCard :(BOOL) moveLeft;
-(void) startEndMove:(CardInfoView *)wordCard :(BOOL) moveLeft :(int)startX;
-(void) endMove;
-(BOOL) startFlip:(CardInfoView *)wordCard;
-(void) startEndFlip:(CardInfoView *)wordCard;
-(void) endFlip;

@end

/* basic function

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