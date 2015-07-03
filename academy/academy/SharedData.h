//
//  SharedData.h
//  academy
//
//  Created by Mac Mini on 6/28/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SharedData;
typedef void(^returnSharedData)(SharedData * returnSharedData);

@protocol SharedDataDelegate <NSObject>
- (void)SharedDataGetSuccessful:(SharedData *) sharedData;
- (void)SharedDataGetFailed:(id)Error StatusCode:(NSNumber*)statusCode;
@end

@interface SharedData : NSObject

@property (nonatomic, weak) id <SharedDataDelegate> sharedDataDelegate;
@property (nonatomic, retain) NSString * appVersion;
@property (nonatomic, retain) NSString * latestDataUpdateDate;
//- (void)updateSharedData;
-(void) updateSharedData:(returnSharedData) block;

@end
