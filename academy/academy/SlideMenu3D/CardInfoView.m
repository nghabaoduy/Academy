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
    
    if (wordSubDict.allKeys.count > 0) {
        switch (self.curLanguageType) {
            case LanguageIndexTypeWord:
                [self underlineWordDict:self.contentTV wordDict:wordSubDict];
                break;
            case LanguageIndexTypeCharacter:
            {
                [self.contentBelowTV setAttributedText:self.contentTV.attributedText];
                [self resizeTextViewToFit:self.contentBelowTV];
                [self underlineWordDict:self.contentBelowTV wordDict:wordSubDict];
            }
                break;
            default:
                break;
        }
    }
}

-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent
{
    [self clearDisplay];
    [self.wordLb setText:word];
    [self.wordTypeLb setText:[NSString stringWithFormat:@"(%@)",wordType]];
    if ([[self.delegate CardInfoViewGetLanguage] isEqualToString:@"English"]) {
        [self.phoneticLb setText:[NSString stringWithFormat:@"/%@/",phonetic]];
    }   else   {
        [self.phoneticLb setText:[NSString stringWithFormat:@"%@",phonetic]];
    }
    
    [self.contentTV setText:@""];
    [self.contentTV setText:detailContent];
    
    self.curLanguageType = [[LanguageControl getInstance] getLanguageIndexTypeByLang:[self.delegate CardInfoViewGetLanguage]];
    self.standardFontSize = [[LanguageControl getInstance] getFontSizeByLang:[self.delegate CardInfoViewGetLanguage]];
    self.contentTV.font= [UIFont fontWithName:@"GothamRounded-Book" size:self.standardFontSize];
    
    [self changeTextViewSubStringAtt:self.contentTV targetText:word color:[UIColor redColor]];
    
    [self resizeTextViewToFit:self.contentTV];
    [self resizeTextViewToFit:self.contentBelowTV];
}

-(void) resizeTextViewToFit:(UITextView *) tv
{
    CGFloat fixedWidth = tv.frame.size.width;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tv.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tv.frame = newFrame;
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
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"GothamRounded-Bold" size:self.standardFontSize] range:subRange];
    }];
    
    [tv setAttributedText:string];
}
-(void) underlineWordDict:(UITextView *) tv wordDict:(NSDictionary *)wordDict
{
    if (!wordDict) {
        return;
    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    switch (self.curLanguageType) {
        case LanguageIndexTypeWord:
        {
            NSArray * allKeys = [wordDict allKeys];
            for (NSString *keyWord in allKeys) {
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:keyWord options:0 error:nil];
                NSRange range = NSMakeRange(0,[tv.text length]);
                [expression enumerateMatchesInString:tv.text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    NSRange subRange = [result rangeAtIndex:0];
                    [string addAttribute:NSUnderlineStyleAttributeName value: @(NSUnderlineStyleSingle| NSUnderlinePatternDot) range:subRange];
                }];
            }
        }
            break;
        case LanguageIndexTypeCharacter:
        {
            NSArray * allKeys = [wordDict allKeys];
            for (NSString *keyWord in allKeys) {
                NSArray *subRangeList = [self getSubRangeList:tv.text forWord:keyWord];
                for (NSValue *rangeValue in subRangeList) {
                    NSRange subRange = [rangeValue rangeValue];
                    //NSLog(@"found Range = [%i,%i]",subRange.location,subRange.length);
                    [string addAttribute:NSUnderlineStyleAttributeName value: @(NSUnderlineStyleSingle| NSUnderlinePatternDot|NSUnderlineStyleThick) range:subRange];
                    [string addAttribute:NSUnderlineColorAttributeName value:[UIColor blackColor] range:subRange];
                }
            }
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, tv.text.length)];
        }
            break;
        case LanguageIndexTypeTypeCount:
            return;
    }
    
   
    [tv setAttributedText:string];
}
-(NSArray *) getSubRangeList:(NSString *) text forWord:(NSString *) word
{
    //NSLog(@"Get [%@] from [%@]",word,text);
    NSMutableArray *subRangeList = [NSMutableArray new];
    for (int i = 0; i<text.length - word.length + 1; i++) {
        NSRange range = NSMakeRange(i, word.length);
        NSString *checkSubStr = [text substringWithRange:range];
        if ([checkSubStr isEqualToString:word]) {
            [subRangeList addObject:[NSValue valueWithRange:range]];
        }
    }
    return subRangeList;
}
-(void) textViewTapped:(UITapGestureRecognizer *)recognizer
{
    //get view
    UITextView *textView = (UITextView *)recognizer.view;
    //get location
    CGPoint location = [recognizer locationInView:textView];
    UITextPosition *tapPosition = [textView closestPositionToPoint:location];
    UITextRange *textRange;

    switch (self.curLanguageType) {
        case LanguageIndexTypeWord:
        {
            textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
            NSLog(@"wordRange = %@", textRange);
        }
            break;
        case LanguageIndexTypeCharacter:
        {
            textRange = [textView characterRangeAtPoint:location];
            NSLog(@"charRange = %@", textRange);
        }
            break;
        case LanguageIndexTypeTypeCount:
            return;
    }
    
    UITextPosition* beginning = textView.beginningOfDocument;
    UITextPosition* selectionStart = textRange.start;
    UITextPosition* selectionEnd = textRange.end;
    
    NSInteger rangeLocation = [textView offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger rangeLength = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];

    
    //return string
    NSString * tappedWord = [textView textInRange:textRange];
    NSLog(@"word = %@",tappedWord);
    if ([tappedWord isEqualToString:@""]) {
        [delegate cardIsTapped:self];
        return;
    }
    for (NSString *key in [wordSubDict allKeys]) {
        if ([self checkIfCharacters:tappedWord inString:textView.text atRange:NSMakeRange(rangeLocation, rangeLength) isInWord:key]) {
            CGRect result1 = [textView firstRectForRange:textRange ];
            
            CGPoint newPos = CGPointMake(textView.frame.origin.x + result1.origin.x + result1.size.width/2,
                                         textView.frame.origin.y + result1.origin.y  + result1.size.height+2);
            [mPopup displayText:[wordSubDict valueForKey:key] atPos:newPos];
            return;
        }
    }
    [mPopup fadeOut];
}
-(BOOL) checkIfCharacters:(NSString*) chars inString:(NSString *)aString atRange:(NSRange) textRange isInWord:(NSString*) word
{
    //NSLog(@"checkIfCharacters[%@] inString[%@] atRange[%i,%i] isInWord[%@]",chars,aString,textRange.location,textRange.length,word);
    if ([chars isEqualToString:word])
        return YES;
    
    NSRange range = [word rangeOfString:chars];
   // NSLog(@"range = [%i,%i]",range.location,range.length);
    if (range.location == NSNotFound)
        return NO;
    
    NSUInteger charsInFront = range.location;
    NSUInteger charsInBack = word.length - range.location - chars.length;
   // NSLog(@"charsInFront,charsInBack = [%i,%i]",charsInFront,charsInBack);
    if (textRange.location >= charsInFront && aString.length >= (textRange.location + textRange.length + charsInBack)) {
        NSString * extractedWord = [aString substringWithRange:NSMakeRange(textRange.location - charsInFront, word.length)];
        //NSLog(@"extractedWord = %@",extractedWord);
        return [[extractedWord lowercaseString] isEqualToString:[word lowercaseString]];
    }
    return NO;
}
-(void) clearDisplay
{
    [self.wordLb setText:@""];
    [self.wordTypeLb setText:@""];
    [self.phoneticLb setText:@""];
    [self.contentTV setText:@""];
    [self.contentBelowTV setText:@""];
    [self.centerWordLb setText:@""];
    [self.messageLb setText:@""];
    mPopup.hidden = YES;
    
}
@end
