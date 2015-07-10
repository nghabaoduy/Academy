//
//  CardInfoView.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageControl.h"
#import "LSet.h"

@class CardInfoView;

@protocol CardInfoViewDelegate
@optional
-(void) cardIsTapped:(CardInfoView *) card;
-(void) exampleSpeakerIsTapped:(CardInfoView *) card;
-(NSString *) CardInfoViewGetLanguage;
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
@property (strong, nonatomic) IBOutlet UITextView *contentBelowTV;
@property (strong, nonatomic) IBOutlet UILabel *messageLb;
@property (strong, nonatomic) IBOutlet UILabel *centerWordLb;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIButton *exampleSpeaker;
@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *cardViewForShadow;
@property (strong, nonatomic) IBOutlet UIImageView *packImgView;
@property (strong, nonatomic) IBOutlet UILabel *setTitle;
@property (strong, nonatomic) IBOutlet UILabel *setSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *setImageView;



@property LanguageIndexType curLanguageType;
@property int standardFontSize;


-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent;
-(void) displayWord:(NSString *) word wordType: (NSString*) wordType phonetic: (NSString*) phonetic detailContent:(NSString*) detailContent wordSubDict:(NSDictionary *) subDict;
-(void) displayCenterWord:(NSString *)word message:(NSString *) message;
-(void) clearDisplay;
-(void) displaySetInfoWithSet:(LSet*)set withPackageImage:(NSString *) imageName;

@end
