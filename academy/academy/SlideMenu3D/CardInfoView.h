//
//  CardInfoView.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardInfoView;

@protocol CardInfoViewDelegate
-(void) cardIsTapped:(CardInfoView *) card;

@end

@interface CardInfoView : UIView
{
    id <CardInfoViewDelegate> delegate;
}
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *wordLb;
@property (strong, nonatomic) IBOutlet UILabel *phoneticLb;
@property (strong, nonatomic) IBOutlet UILabel *wordTypeLb;
@property (strong, nonatomic) IBOutlet UITextView *contentTV;
@property (strong, nonatomic) IBOutlet UIView *view;

-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent;

@end
