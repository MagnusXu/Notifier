//
//  MsgD.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/9.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface MsgD : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *preview;
@property (nonatomic, strong) NSString *bodyHTML;

@property (nonatomic, strong) NSNumber *msgID;
@property (nonatomic, strong) NSNumber *msgType;
@property (nonatomic, strong) NSNumber *groupID;
@property (nonatomic, strong) NSNumber *userID;

@property (nonatomic, strong) UserInfo *user;

@property (nonatomic, strong) NSNumber *bodyType;
@property (nonatomic, strong) NSNumber *hitsCount;
@property (nonatomic, strong) NSNumber *readCount;
@property (nonatomic, strong) NSNumber *replyCount;
@property (nonatomic, strong) NSDate *addTime;

@property (nonatomic, assign) BOOL read;

@end
