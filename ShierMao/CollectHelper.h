//
//  CollectHelper.h
//  ShierMao
//
//  Created by 孙铭 on 15/11/2.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPageTableVC.h"

@class MsgC;

@interface CollectHelper : NSObject
@property (nonatomic, weak) MainPageTableVC *mainVC;

+ (void)setMainVC:(MainPageTableVC *)mainVC;

+ (NSArray *)getCollectMsgAry;

+ (void)addCollectMsg:(MsgC *)msg withIndex:(NSInteger)index;
+ (void)removeCollectMsgWithID:(NSNumber *)msgID withIndex:(NSInteger)index;
@end
