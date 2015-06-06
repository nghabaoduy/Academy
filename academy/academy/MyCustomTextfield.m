//
//  MyCustomTextfield.m
//  academy
//
//  Created by Brian on 6/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "MyCustomTextfield.h"

@implementation MyCustomTextfield

@synthesize myPlaceHolder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    myPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, 25) ];
    [myPlaceHolder setText:@"Partenza:"];
    
    [myPlaceHolder setTextColor:[UIColor grayColor]];
    self.leftView = myPlaceHolder;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}

-(void) setPlaceholder:(NSString *)placeholderText
{
    // NSLog(@"placeholder set: %@",placeholderText);
    UIFont *font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
    [myPlaceHolder setFont:font];
    
    
    self.myPlaceHolder.text = [NSString stringWithFormat:@"  %@",placeholderText];
    [self.myPlaceHolder sizeToFit];
    
    NSRange isSpacedRange = [placeholderText rangeOfString:@"*" options:NSCaseInsensitiveSearch];
    if(isSpacedRange.location != NSNotFound) {
        [myPlaceHolder setTextColor:[UIColor redColor]];
    }
    
}

@end
