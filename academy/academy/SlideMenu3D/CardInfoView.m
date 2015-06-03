//
//  CardInfoView.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardInfoView.h"
#import "MeaningPopupDisplayer.h"
@implementation CardInfoView
{
    MeaningPopupDisplayer * mPopup;
    NSDictionary * wordSubDict;
}

@synthesize delegate;

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
    [[NSBundle mainBundle] loadNibNamed:@"CardInfo" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    
    [self.contentTV setSelectable:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    [self.contentTV addGestureRecognizer:gestureRecognizer];
    
    mPopup = [[MeaningPopupDisplayer alloc] init];
    [self addSubview:mPopup];
}
- (IBAction)touchUpInside:(id)sender {
    //NSLog(@"touchUpInside");
    [delegate cardIsTapped:self];
}
-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent wordSubDict:(NSDictionary *) subDict
{
    wordSubDict = subDict;
    [self displayWord:word wordType:wordType phonetic:phonetic detailContent:detailContent];
    [self underlineWordDict:self.contentTV wordDict:wordSubDict];
    
}
-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent
{
    [self clearDisplay];
    [self.wordLb setText:word];
    [self.wordTypeLb setText:[NSString stringWithFormat:@"(%@)",wordType]];
    [self.phoneticLb setText:[NSString stringWithFormat:@"/%@/",phonetic]];
    [self.contentTV setText:@""];
    [self.contentTV setText:detailContent];
    [self changeTextViewSubStringAtt:self.contentTV targetText:word color:[UIColor redColor]];
    [self underlineWordDict:self.contentTV wordDict:wordSubDict];
    
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
-(void) underlineWordDict:(UITextView *) tv wordDict:(NSDictionary *)wordDict
{
    if (!wordDict) {
        return;
    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    NSArray * allKeys = [wordDict allKeys];
    for (NSString *keyWord in allKeys) {
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:keyWord options:0 error:nil];
        NSRange range = NSMakeRange(0,[tv.text length]);
        [expression enumerateMatchesInString:tv.text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange subRange = [result rangeAtIndex:0];
            [string addAttribute:NSUnderlineStyleAttributeName value: @(NSUnderlineStyleSingle| NSUnderlinePatternDot) range:subRange];
        }];
    }
   
    [tv setAttributedText:string];
}
-(void) textViewTapped:(UITapGestureRecognizer *)recognizer
{
    //get view
    UITextView *textView = (UITextView *)recognizer.view;
    //get location
    CGPoint location = [recognizer locationInView:textView];
    UITextPosition *tapPosition = [textView closestPositionToPoint:location];
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    
    //return string
    NSString * word = [textView textInRange:textRange];
    if ([word isEqualToString:@""]) {
        [delegate cardIsTapped:self];
        return;
    }
    for (NSString *key in [wordSubDict allKeys]) {
        if ([key isEqualToString:word]) {
            CGRect result1 = [textView firstRectForRange:textRange ];
            
            CGPoint newPos = CGPointMake(textView.frame.origin.x + result1.origin.x + result1.size.width/2,
                                         textView.frame.origin.y + result1.origin.y  + result1.size.height+2);
            [mPopup displayText:[wordSubDict valueForKey:key] atPos:newPos];
            return;
        }
    }
    [mPopup fadeOut];
}
-(void) clearDisplay
{
    [self.wordLb setText:@""];
    [self.wordTypeLb setText:@""];
    [self.phoneticLb setText:@""];
    [self.contentTV setText:@""];
    [self.centerWordLb setText:@""];
    [self.messageLb setText:@""];
    mPopup.hidden = YES;
    
}
@end
