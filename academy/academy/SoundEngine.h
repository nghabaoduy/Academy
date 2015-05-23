//
//  SoundEngine.h
//  academy
//
//  Created by Brian on 5/23/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundEngine : NSObject

+ (id)getInstance;
- (void)playSound:(NSString*)fileNameWithExtension ;
@end
