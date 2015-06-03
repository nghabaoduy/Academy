//
//  AlertMascotView.m
//  academy
//
//  Created by Brian on 6/3/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AlertMascotView.h"

@implementation AlertMascotView
{
    
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
    [[NSBundle mainBundle] loadNibNamed:@"AlertMascotDisplayView" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    self.layer.anchorPoint = CGPointMake(0, 0);
    self.layer.bounds = self.view.bounds;
    self.view.backgroundColor = [UIColor clearColor];
    
}

@end
