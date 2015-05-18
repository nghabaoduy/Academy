//
//  LoadingUIView.h
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingUIView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
- (void) startLoading;
-(void) endLoading;
@end
