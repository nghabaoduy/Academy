//
//  LanguageControl.h
//  academy
//
//  Created by Brian on 6/16/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LanguageIndexType) {
    LanguageIndexTypeWord,
    LanguageIndexTypeCharacter,
    LanguageIndexTypeTypeCount
};

@interface LanguageControl : NSObject
+ (id)getInstance;
-(NSString *) getLanguageVoiceCodeByLang:(NSString *) lang;
-(LanguageIndexType) getLanguageIndexTypeByLang:(NSString *) lang;
-(int) getFontSizeByLang:(NSString *) lang;
@end
