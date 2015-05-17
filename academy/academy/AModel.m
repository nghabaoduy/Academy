//
//  AModel.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"

@implementation AModel

- (void)findId:(NSString *)valId {
    AModel * newModel = [AModel new];
    newModel.modelId = valId;
    
    [self.delegate findIdSuccessful:newModel];
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    
    //[self.delegate getAllSucessfull:@[]];
}

- (void)createModel {
    [self.delegate createModelSuccessful:self];
}

- (void)updateModel {
    [self.delegate updateModelSuccessful:self];
}

- (void)deleteModel {
    [self.delegate deleteModelSuccessful:self];
}

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    
}

- (NSDictionary *)getDictionaryFromObject {
    return @{};
}

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setObjectWithDictionary:dict];
    }
    return self;
}

- (NSString *)getStringFromDict:(NSDictionary *)dict WithKey:(NSString *)key {
    if ([dict[key] isEqual:[NSNull null]]) {
        return nil;
    }
    return dict[key];
}

@end
