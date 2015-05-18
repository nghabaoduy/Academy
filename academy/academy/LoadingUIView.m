//
//  LoadingUIView.m
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LoadingUIView.h"

@implementation LoadingUIView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        [self setHidden:YES];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        [self setHidden:YES];
    }
    return self;
}
- (void) startLoading
{
    [self setHidden:NO];
    
}
-(void) endLoading
{
    [self setHidden:YES];
}
- (void)didMoveToSuperview
{
    self.layer.anchorPoint = CGPointMake(0,0);
    [self setCenter:CGPointMake(0,0)];
  
   [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.superview.frame.size.width, self.superview.frame.size.height)];
    
}


@end
