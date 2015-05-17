//
//  AModel.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataEngine.h"


@class AModel;
@protocol ModelDelegate <NSObject>

@optional
- (void)getAllSucessfull:(NSMutableArray *)allList;
- (void)findIdSuccessful:(AModel*)model;
- (void)createModelSuccessful:(AModel *)model;
- (void)updateModelSuccessful:(AModel *)model;
- (void)deleteModelSuccessful:(AModel *)model;

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode;
- (void)findWithErrorMessage:(NSDictionary *)error;

@end

@interface AModel : NSObject

@property (nonatomic, strong) NSString * modelId;
@property (nonatomic, weak) id <ModelDelegate> delegate;
- (id)initWithDict:(NSDictionary*)dict;
- (void)getAllWithFilter:(NSDictionary*)filterDictionary;
- (void)findId:(NSString*)valId;
- (void)createModel;
- (void)updateModel;
- (void)deleteModel;

- (void)setObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary*)getDictionaryFromObject;

- (NSString*)getStringFromDict:(NSDictionary*)dict WithKey:(NSString*)key;

@end
