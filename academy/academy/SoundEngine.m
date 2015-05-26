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
    AVSpeechSynthesizer *synthesizer;
}

static SoundEngine * instance = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [[SoundEngine alloc] init];
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        synthesizer.delegate = self;
        for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
            NSLog(@"%@", voice.language);
        }
    }
    return self;
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
- (void) readWord:(NSString*)word
{
    if ([synthesizer isPaused]) {
        [synthesizer continueSpeaking];
    }else{
        [self speakText:word];
    }
}
- (void)speakText:(NSString*)text{
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-au"];
    
    [synthesizer speakUtterance:utterance];
}
@end
