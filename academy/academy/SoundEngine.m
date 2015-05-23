//
//  SoundEngine.m
//  academy
//
//  Created by Brian on 5/23/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SoundEngine.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation SoundEngine
{
    AVAudioPlayer *audioPlayerObj;
}

static SoundEngine * instance = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [SoundEngine new];
    }
    return instance;
}

- (void)playSound:(NSString*)fileNameWithExtension {
    
    if(!audioPlayerObj)
        audioPlayerObj = [AVAudioPlayer alloc];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],fileNameWithExtension];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    audioPlayerObj = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayerObj play];
    
}

@end
