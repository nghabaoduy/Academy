//
//  MyUIEngine.h
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface MyUIEngine : NSObject
+ (id)sharedUIEngine;

-(void)appDelegateUICustomzation;
+(void) popButton:(UIView *) button;
+(void) popAppearButton:(UIView *) button;
+(void) popAppearButton:(UIView *) button withDelay:(CGFloat) delay;
+(void) popDisappearButton:(UIView *) button;
@end
