//
//  SetCollectionCell.h
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDisplayer.h"
#import "LSet.h"


@interface SetCollectionCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet SetDisplayer *setDisplayer;
@property (weak, nonatomic) IBOutlet UIView *solidBG;
@property (weak, nonatomic) IBOutlet UIView *solidBGAnimation;
@property (weak, nonatomic) UIColor *solidColor;
@property (strong, retain) LSet * curSet;

-(void) resetView;
-(void) setAppearAfterDelay:(CGFloat) time;
@end
