//
//  SetDisplayer.m
//  academy
//
//  Created by Brian on 6/1/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetDisplayer.h"
#import "UIImageView+AFNetworking.h"

@implementation SetDisplayer
{
    IBOutlet UIImageView *img;
    IBOutlet UIImageView *rankImg;
    IBOutlet UILabel *titleLb;
    LSet* curSet;
    Package * curPack;
    
    
}
@synthesize delegate;
@synthesize isFinalTest, isEnabled;
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
    isFinalTest = NO;
    [titleLb setText:set.name];
    //NSLog(@"set.imgURL = %@",set.imgURL);
    if (set.imgURL)
        [img setImageWithURL:[NSURL URLWithString:set.imgURL] placeholderImage:[UIImage imageNamed:@"sticker_egg.png"]];
    else
        [img setImage:[UIImage imageNamed:set.dummyImgName]];
    
    if ([set.grade intValue] == 0) {
        [rankImg setHidden:YES];
        [self disableDisplayer];
    }
    else
    {
        [rankImg setHidden:NO];
        [rankImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rankStar_%i.png",[set.grade intValue]]]];
        [self enableDisplayer];
    }
}
-(void) setFinalTest:(Package *) pack
{
    curPack = pack;
    isFinalTest = YES;
    [titleLb setText:@"Tổng Kiểm Tra"];
    [rankImg setHidden:YES];
    [img setImage:[UIImage imageNamed:@"sticker_finaltest.png"]];
}
-(LSet *) getLSet
{
    return curSet;
}
- (IBAction)touchInside:(id)sender {
    //if (isEnabled) {
        [delegate setDisplayerClicked:self];
    //}
}

-(void) disableDisplayer
{
    isEnabled = NO;
    self.layer.opacity = 0.2;
}
-(void) enableDisplayer
{
    isEnabled = YES;
    self.layer.opacity = 1;
}

@end
