//
//  SoundEngine.h
//  academy
//
//  Created by Brian on 5/23/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVSpeechSynthesis.h>

@interface SoundEngine : NSObject<AVSpeechSynthesizerDelegate>

+ (id)getInstance;
- (void)playSound:(NSString*)fileNameWithExtension ;
- (void) readWord:(NSString*)word;
@end
