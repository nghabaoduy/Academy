//
//  SetInfoCollectionCell.h
//  academy
//
//  Created by Mac Mini on 7/10/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetInfoCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

-(void) resetView;
-(void) setAppearAfterDelay:(CGFloat) time;
-(void) animateViewDisappearLeft;
-(void) animateViewDisappearRight;
@end
