//
//  MeaningPopupDisplayer.m
//  academy
//
//  Created by Brian on 6/3/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "MeaningPopupDisplayer.h"

@implementation MeaningPopupDisplayer
{
    IBOutlet UILabel *textLb;
    BOOL isInAnimation;
    NSString *displayStr;
    CGPoint pos;
    
}

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
    [[NSBundle mainBundle] loadNibNamed:@"MeaningPopup" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    self.layer.anchorPoint = CGPointMake(0.5, 0);
    self.layer.bounds = self.view.bounds;
    
    self.hidden = YES;
}
- (IBAction)tapped:(id)sender {
    [self fadeOut];
}
-(void) displayText:(NSString *) text atPos:(CGPoint) newPos
{
    displayStr = text;
    if (displayStr.length == 0) {
        return;
    }
    pos = newPos;
    if (self.hidden == YES) {
        [textLb setText:displayStr];
        [textLb sizeToFit];
        [self performSelector:@selector(fadeIn) withObject:self afterDelay:0.01f];
    }
    else
    {
        [self fadeOut];
    }
}
-(void) fadeIn
{
    self.hidden = NO;
    isInAnimation = YES;
    

    [self setFrame:CGRectMake(0, 0, textLb.frame.size.width+16, textLb.frame.size.height + 16)];
    self.layer.position = pos;
    self.layer.opacity = 0.0f;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.opacity = 1.0f;
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             isInAnimation = NO;
                         }
                     }];
    
    
}
-(void) fadeOut
{
    if (isInAnimation || self.hidden == YES) {
        return;
    }
    self.hidden = NO;
    isInAnimation = YES;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL b) {
                         if (b) {
                             self.hidden = YES;
                             isInAnimation = NO;
                             if (![textLb.text isEqualToString:displayStr]) {
                                 [textLb setText:displayStr];
                                 [textLb sizeToFit];
                                 [self performSelector:@selector(fadeIn) withObject:self afterDelay:0.05f];
                             }
                         }
                     }];
    
    
}
@end
