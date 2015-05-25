//
//  AlertCartoonView.m
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AlertCartoonView.h"

@implementation AlertCartoonView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CartoonView" owner:self options:nil];
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
        [[NSBundle mainBundle] loadNibNamed:@"CartoonView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.layer.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}
@end
