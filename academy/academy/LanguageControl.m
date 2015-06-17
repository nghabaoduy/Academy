//
//  LanguageControl.m
//  academy
//
//  Created by Brian on 6/16/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LanguageControl.h"

@implementation LanguageControl{
    NSDictionary *languageVoiceCodeDict;
    NSArray *languageCharacterIndexTypeList;
}

static LanguageControl * instance = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [[LanguageControl alloc] init];
    }
    return instance;
}
- (id)init {
    if (self = [super init]) {
        languageVoiceCodeDict = @{
                                  @"English"    : @"en-au",
                                  @"Chinese"    : @"zh-TW",
                                  @"French"     : @"fr-FR",
                                  @"German"     : @"de-DE",
                                  @"Hindi"      : @"hi-IN",
                                  @"Italian"    : @"it-IT",
                                  @"Japanese"   : @"ja-JP",
                                  @"Korean"     : @"ko-KR"
                                  };
        languageCharacterIndexTypeList = @[
                                           @"Chinese",
                                           @"Hindi",
                                           @"Japanese",
                                           @"Korean"
                                           ];
    }
    return self;
}

-(NSString *) getLanguageVoiceCodeByLang:(NSString *) lang{
    for (NSString * key in [languageVoiceCodeDict allKeys]) {
        if ([key isEqualToString:lang]) {
            return languageVoiceCodeDict[key];
        }
    }
    return @"en-au";
}
-(LanguageIndexType) getLanguageIndexTypeByLang:(NSString *) lang{
    
    for (NSString *langRef in languageCharacterIndexTypeList) {
        if ([langRef isEqualToString:lang]) {
            return LanguageIndexTypeCharacter;
        }
    }
    return LanguageIndexTypeWord;
}
-(int) getFontSizeByLang:(NSString *) lang{
    for (NSString *langRef in languageCharacterIndexTypeList) {
        if ([langRef isEqualToString:lang]) {
            return 16;
        }
    }
    return 14;
}
@end
