//
//  CollectHelper.m
//  ShierMao
//
//  Created by 孙铭 on 15/11/2.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "CollectHelper.h"
#import "MsgC.h"

@implementation CollectHelper

+ (CollectHelper *)sharedHelper {
    static CollectHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [self new];
    });
    return helper;
}

+ (void)setMainVC:(MainPageTableVC *)mainVC {
    [self sharedHelper].mainVC = mainVC;
}

+ (NSArray *)getCollectMsgAry {
    NSNumber *userID = [USER_DEFAULT objectForKey:USER_INFO_ID_DEFAULT_KEY];
    NSString *kUserID = [userID stringValue];
    return [[NSDictionary dictionaryWithContentsOfFile:[self pathOfPlist]][kUserID] bk_map:^id(id obj){
        MsgC *msg = [MsgC new];
        msg.title = obj[@"title"];
        msg.preview = obj[@"preview"];
        msg.readCount = obj[@"readCount"];
        msg.ID = obj[@"id"];
        msg.addTime = obj[@"addTime"];
        msg.rowIndex = obj[@"index"];
        return msg;
    }];
}

+ (void)addCollectMsg:(MsgC *)msg withIndex:(NSInteger)index {
    NSNumber *userID = [USER_DEFAULT objectForKey:USER_INFO_ID_DEFAULT_KEY];
    NSString *kUserID = [userID stringValue];
    NSDictionary *msgDic = @{@"title": msg.title, @"preview": msg.preview, @"readCount": msg.readCount, @"id": msg.ID, @"addTime": msg.addTime, @"index": [NSNumber numberWithInteger:index]};
    NSMutableDictionary *plistDic = [[NSDictionary dictionaryWithContentsOfFile:[self pathOfPlist]] mutableCopy];
    NSMutableArray *plistAry = [[plistDic objectForKey:kUserID] mutableCopy];
    if (!plistAry) {
        plistAry = [[NSMutableArray alloc] init];
    }
    [plistAry addObject:msgDic];
    [plistDic setObject:plistAry forKey:kUserID];
    [plistDic writeToFile:[self pathOfPlist] atomically:YES];
}

+ (void)removeCollectMsgWithID:(NSNumber *)msgID withIndex:(NSInteger)index {
    NSNumber *userID = [USER_DEFAULT objectForKey:USER_INFO_ID_DEFAULT_KEY];
    NSString *kUserID = [userID stringValue];
    NSMutableDictionary *plistDic = [[NSMutableDictionary dictionaryWithContentsOfFile:[self pathOfPlist]] mutableCopy];
    NSMutableArray *plistAry = [[plistDic objectForKey:kUserID] mutableCopy];
    NSDictionary *msgDic = [plistAry bk_match:^BOOL(NSDictionary *obj){
        return [obj[@"id"] isEqual:msgID];
    }];
    if (index != 0) {
        [[self sharedHelper].mainVC cancelHightedWithRowIndex:index];
    }
    [plistAry removeObject:msgDic];
    [plistDic setObject:plistAry forKey:kUserID];
    [plistDic writeToFile:[self pathOfPlist] atomically:YES];
}

+ (NSString *)pathOfPlist {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [docPath stringByAppendingString:@"/collectMsg.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath]) {
        [[NSDictionary dictionary] writeToFile:plistPath atomically:YES];
    }
    return plistPath;
}

@end
