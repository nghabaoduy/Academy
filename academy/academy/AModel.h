//
//  AModel.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AModel;
@protocol ModelDelegate <NSObject>

@optional
- (void)getAllSucessfull:(NSArray *)allList;
- (void)findIdSuccessful:(AModel*)model;
- (void)createModelSuccessful:(AModel *)model;
- (void)updateModelSuccessful:(AModel *)model;
- (void)deleteModelSuccessful:(AModel *)model;

- (void)model:(AModel *)model ErrorMessage:(NSDictionary *)error;
+ (void)findWithErrorMessage:(NSDictionary *)error;

@end

@interface AModel : NSObject

@property (nonatomic, strong) NSString * modelId;
@property (nonatomic, weak) id <ModelDelegate> delegate;

- (void)getAllWithFilter:(NSDictionary*)filterDictionary;
- (void)findId:(NSString*)valId;
- (void)createModel;
- (void)updateModel;
- (void)deleteModel;

- (void)setObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary*)getDictionaryFromObject;

@end
