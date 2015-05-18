//
//  Meaning.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 18/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Meaning.h"

@implementation Meaning


- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _language = [self getStringFromDict:dict WithKey:@"language"];
    _content = [self getStringFromDict:dict WithKey:@"content"];
    _wordId = [self getStringFromDict:dict WithKey:@"wordId"];
    _example = [self getStringFromDict:dict WithKey:@"example"];
}
@end
