//
//  AlertTestModePickView.m
//  academy
//
//  Created by Brian on 5/29/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AlertTestModePickView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlertTestModePickView
{
    IBOutlet UILabel *testInfoLb;

}
@synthesize delegate;

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
    [[NSBundle mainBundle] loadNibNamed:@"TestModePickView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.backgroundColor = [UIColor clearColor];
    self.layer.anchorPoint = CGPointMake(0, 0);
    self.layer.bounds = self.view.bounds;
}

- (IBAction)mode1Click:(id)sender {
    NSLog(@"mode1 clicked");
    [delegate AlertTestModePickView:self modePicked:TestPickNormal];
}
- (IBAction)mode2Click:(id)sender {
    NSLog(@"mode2 clicked");
    [delegate AlertTestModePickView:self modePicked:TestPickTimer];
}
-(void) setTestTimeText:(int) sec
{
    [testInfoLb setText:[NSString stringWithFormat:@"Bạn có %is để hoàn thành bài kiểm tra",sec]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
