//
//  CardInfoView.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardInfoView.h"

@implementation CardInfoView

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardInfo" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardInfo" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    return self;
}
- (IBAction)touchUpInside:(id)sender {
    NSLog(@"touchUpInside");
    [delegate cardIsTapped:self];
}
-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent {
    [self.wordLb setText:word];
    [self.wordTypeLb setText:[NSString stringWithFormat:@"(%@)",wordType]];
    [self.phoneticLb setText:[NSString stringWithFormat:@"/%@/",phonetic]];
    [self.contentTV setText:detailContent];
}
@end
