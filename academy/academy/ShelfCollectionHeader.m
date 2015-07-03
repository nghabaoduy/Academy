//
//  ShelfCollectionHeader.m
//  academy
//
//  Created by Mac Mini on 7/3/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShelfCollectionHeader.h"

@implementation ShelfCollectionHeader
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
    [[NSBundle mainBundle] loadNibNamed:@"ShelfColHeader" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    //self.layer.anchorPoint = CGPointMake(0.5, 0);
    self.layer.bounds = self.view.bounds;
}
@end
