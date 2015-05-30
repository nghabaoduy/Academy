//
//  AlertTestModePickView.m
//  academy
//
//  Created by Brian on 5/29/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AlertTestModePickView.h"

@implementation AlertTestModePickView
{
    IBOutlet UIButton *mode1Btn;
    IBOutlet UIButton *mode2Btn;
}
@synthesize delegate;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TestModePickView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.layer.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TestModePickView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.layer.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}
- (IBAction)mode1Click:(id)sender {
    [delegate AlertTestModePickView:self modePicked:TestPickNormal];
}
- (IBAction)mode2Click:(id)sender {
    [delegate AlertTestModePickView:self modePicked:TestPickTimer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
