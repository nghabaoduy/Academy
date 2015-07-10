//
//  SetInfoCollectionCell.m
//  academy
//
//  Created by Mac Mini on 7/10/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetInfoCollectionCell.h"

@implementation SetInfoCollectionCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(void) initView
{
    [[NSBundle mainBundle] loadNibNamed:@"SetInfoCollectionViewCell" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.layer.bounds = self.view.bounds;
    
    self.backgroundColor = [UIColor clearColor];
    self.view.layer.cornerRadius = 7;
    self.clipsToBounds = NO;
    self.hidden = YES;
    
}

-(void) resetView
{
    self.userInteractionEnabled = YES;
    self.hidden = NO;
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
}

-(void) setAppearAfterDelay:(CGFloat) time
{
    
    [self performSelector:@selector(animateViewAppear) withObject:self afterDelay:time];
}
-(void) initAnimation
{
    self.userInteractionEnabled = NO;
    
}
- (void) animateViewAppear
{
    self.userInteractionEnabled = NO;
    self.hidden = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGPoint oriPos = self.view.layer.position;
    self.view.layer.position = CGPointMake(self.view.layer.position.x + screenSize.width, self.view.layer.position.y);
    [UIView animateWithDuration:2.0
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         //CGFloat amount = 700;
                         
                         self.view.layer.position= oriPos;
                         //view.frame = CGRectOffset(view.frame, amount, 0);

                     } completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];
}

-(void) animateViewDisappearLeft
{
    self.userInteractionEnabled = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(-screenSize.width, 0);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}
-(void) animateViewDisappearRight
{
    self.userInteractionEnabled = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(screenSize.width, 0);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}
@end
