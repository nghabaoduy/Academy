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
- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList;
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
- (NSArray*)getArrayFromDict:(NSDictionary*)dict WithKey:(NSString*)key;
- (NSNumber*)getNumberFromDict:(NSDictionary*)dict WithKey:(NSString*)key;
- (NSDate *)getDateFromDict:(NSDictionary *)dict WithKey:(NSString *)key;
- (NSDictionary*)getDictFromDict:(NSDictionary*)dict WithKey:(NSString*)key;

-(NSArray *) filterNSArrayWithFilter:(NSArray *) aArray Filter:(NSDictionary*) filter;

-(NSString*) getUserDefaultStoredKey;
-(void) saveToNSUserDefaults;
@end
