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
    [self.contentTV setText:@""];
    [self.contentTV setText:detailContent];
    [self changeTextViewSubStringAtt:self.contentTV targetText:word color:[UIColor redColor]];
    
}
-(void) displayCenterWord:(NSString *)word message:(NSString *) message
{
    [self clearDisplay];
    [self.messageLb setText:message];
    [self.centerWordLb setText:word];
}
-(void) changeTextViewSubStringAtt:(UITextView *) tv targetText:(NSString *)targetText color:(UIColor *) color
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:4];
    
    NSDictionary *attrsDictionary = @{NSFontAttributeName: tv.font, NSParagraphStyleAttributeName: paragraphStyle};
    tv.attributedText = [[NSAttributedString alloc] initWithString:tv.text attributes:attrsDictionary];
    
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:targetText options:0 error:nil];
    NSRange range = NSMakeRange(0,[tv.text length]);
    [expression enumerateMatchesInString:tv.text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subRange = [result rangeAtIndex:0];
        [string addAttribute:NSForegroundColorAttributeName value:color range:subRange];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"GothamRounded-Bold" size:14] range:subRange];
    }];
    
    
    
    [tv setAttributedText:string];
}
-(void) clearDisplay
{
    [self.wordLb setText:@""];
    [self.wordTypeLb setText:@""];
    [self.phoneticLb setText:@""];
    [self.contentTV setText:@""];
    [self.centerWordLb setText:@""];
    [self.messageLb setText:@""];
}
@end
