//
//  TermNAgreementDisplayer.m
//  academy
//
//  Created by Brian on 6/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "TermNAgreementDisplayer.h"

@implementation TermNAgreementDisplayer
{
    IBOutlet UITextView *termContentTV;
    
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
    [[NSBundle mainBundle] loadNibNamed:@"TermNAgreementView" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    self.layer.anchorPoint = CGPointMake(0, 0);
    self.layer.bounds = self.view.bounds;
    self.view.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:10];
    
    NSDictionary *attrsDictionary = @{NSFontAttributeName: termContentTV.font, NSParagraphStyleAttributeName: paragraphStyle};
    termContentTV.attributedText = [[NSAttributedString alloc] initWithString:termContentTV.text attributes:attrsDictionary];
}

@end
