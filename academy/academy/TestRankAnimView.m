//
//  TestRankAnimView.m
//  academy
//
//  Created by Brian on 6/2/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "TestRankAnimView.h"
#import "UIImageView+AFNetworking.h"

@implementation TestRankAnimView
{
    IBOutlet UIImageView *setIcon;
    
    IBOutlet UIImageView *wreath;
    IBOutlet UIImageView *ribbon;
    IBOutlet UIImageView *rankStar;
    LSet * curSet;
    IBOutlet UILabel *messageLb;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TestRankingView" owner:self options:nil];
        
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(0, 0);
        self.layer.bounds = self.view.bounds;
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TestRankingView" owner:self options:nil];
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(0, 0);
        self.layer.bounds = self.view.bounds;
        
    }
    return self;
}
-(void) setMessage:(NSString *) message
{
    [messageLb setText:message];
}
-(void) setLSet:(LSet *) set grade:(int)grade
{
    curSet = set;
    if (set.imgURL)
        [setIcon setImageWithURL:[NSURL URLWithString:set.imgURL] placeholderImage:[UIImage imageNamed:@"sticker_egg.png"]];
    else
        [setIcon setImage:[UIImage imageNamed:set.dummyImgName]];
    
    [rankStar setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rankStar_%i.png",grade]]];
    
    [self performScale:setIcon:0.5f:0.0f];
    [self performScale:wreath:0.6f:0.0f];
    [self performScale:ribbon:0.7f:0.0f];
    [self performScale:rankStar:0.8f:0.0f];
    
}
-(void) setPackage:(Package *) pack grade:(int) grade
{

    [setIcon setImage:[UIImage imageNamed:@"sticker_timer.png"]];
    
    [rankStar setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rankStar_%i.png",grade]]];
    
    [self performScale:setIcon:0.5f:0.0f];
    [self performScale:wreath:0.6f:0.0f];
    [self performScale:ribbon:0.7f:0.0f];
    //[self performScale:rankStar:0.8f:0.0f];
}
-(void) performScale:(UIView *) target :(CGFloat) duration :(CGFloat) delay
{
    target.layer.transform = CATransform3DMakeScale(0.1f, 0.1f, 1.0);
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         target.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             [self startEndScale:target:0.5f];
                         }
                     }];
    
    
}
-(void) startEndScale:(UIView *)target :(CGFloat) duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         target.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             [self endScale];
                         }
                     }];
}
-(void) endScale
{
    
}

@end
