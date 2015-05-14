//
//  WordInfoVC.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardParentVC.h"
#import "CardInfoView.h"

@interface WordInfoVC : CardParentVC <CardInfoViewDelegate>
@property (strong, nonatomic) IBOutlet CardInfoView *wordCard;
@property (strong, nonatomic) IBOutlet UILabel *wordNoLb;

@end
