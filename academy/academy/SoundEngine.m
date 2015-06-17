//
//  SoundEngine.m
//  academy
//
//  Created by Brian on 5/23/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SoundEngine.h"
#import "LanguageControl.h"
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
    }
    return self;
}


- (void)playSound:(NSString*)fileNameWithExtension
{
    if(!audioPlayerObj)
        audioPlayerObj = [AVAudioPlayer alloc];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],fileNameWithExtension];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    audioPlayerObj = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayerObj play];
}
- (void) readWord:(NSString*)word language:(NSString *) lang
{
    if ([synthesizer isPaused]) {
        [synthesizer continueSpeaking];
    }else{
        [self stopSpeech];
        [self speakText:word language:lang];
    }
}
- (void)stopSpeech
{
    AVSpeechSynthesizer *talked = synthesizer;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}
- (void)speakText:(NSString*)text language:(NSString *) lang{
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[LanguageControl getInstance] getLanguageVoiceCodeByLang:lang]];
    
    [synthesizer speakUtterance:utterance];
}

@end
