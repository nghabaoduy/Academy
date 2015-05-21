//
//  SideMenuHeader.m
//  academy
//
//  Created by Brian on 5/21/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SideMenuHeader.h"

@implementation SideMenuHeader

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SideMenuHeaderView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SideMenuHeaderView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
