//
//  SetDisplayer.m
//  academy
//
//  Created by Brian on 6/1/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetDisplayer.h"


@implementation SetDisplayer
{
    IBOutlet UIImageView *img;
    IBOutlet UIImageView *rankImg;
    IBOutlet UILabel *titleLb;
    LSet* curSet;
}
@synthesize delegate;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SetIconView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SetIconView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void) setLSet:(LSet *) set
{
    curSet = set;
    [titleLb setText:set.name];
    if ([set.grade intValue] == 0) {
        [rankImg setHidden:YES];
    }
    else
    {
        [rankImg setHidden:NO];
        [rankImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rankStar_%i.png",[set.grade intValue]]]];
    }
}
-(LSet *) getLSet
{
    return curSet;
}
- (IBAction)touchInside:(id)sender {
    [delegate setDisplayerClicked:self];
}

@end