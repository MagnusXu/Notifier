//
//  Reply.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/9.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Reply : NSObject

@property (nonatomic, strong) NSNumber *iD;
@property (nonatomic, strong) NSNumber *msgID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *replyTime;

@end
