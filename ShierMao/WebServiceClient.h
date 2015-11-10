//
//  WebServiceClient.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/7.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenDTO;
@class LoginDTO;
@class MsgListDTO;
@class RegistDTO;
@class MsgD;
@class ReplyDTO;
@class GroupPreview;

@interface WebServiceClient : NSObject

+ (void)registWithRegistDTO:(RegistDTO *)dto
                    success:(void (^) ())success
                    failure:(void (^) (NSString *msg))failure;

+ (void)fetchUniversityListWithSuccess:(void (^)(NSArray *ary))success
                               failure:(void (^) (NSString *msg))failure;

+ (void)loginWithLoginDTO:(LoginDTO *)dto
                  success:(void (^) ())success
                  failure:(void (^) (NSString *msg))failure;

+ (void)fetchMyGroupsWithSuccess:(void (^) (NSArray *ary))success
                         failure:(void (^) (NSString *msg))failure;

+ (void)fetchMsgListWithGroupID:(MsgListDTO *)dto
                        success:(void (^) (NSArray *msgList))success
                        failure:(void (^) (NSString *msg))failure;

+ (void)fetchMsgDetailWithMsgID:(NSNumber *)msgID
                        success:(void (^) (MsgD *msgDetail))success
                        failure:(void (^) (NSString *msg))failure;

+ (void)searchGroupWithGroupName:(NSString *)groupName
                         success:(void (^) (NSArray *ary))success
                         failure:(void (^) (NSString *msg))failure;

+ (void)fetchGourpPreviewWithGroupID:(NSInteger *)groupID
                             Success:(void (^) (GroupPreview *preview))success
                             failure:(void (^) (NSString *msg))failure;

+ (void)applySentWithGroupID:(NSNumber *)groupID body:(NSString *)body;

+ (void)fetchReplyListWithMsgID:(ReplyDTO *)dto
                        success:(void (^) (NSArray *replyList))success
                        failure:(void (^) (NSString *msg))failure;

+ (void)sendReadWithMsgID:(NSNumber *)msgID success:(void (^) ())success;

+ (void)sendReplyWithMsgID:(NSNumber *)msgID
                      body:(NSString *)body
                   success:(void (^) ())success
                   failure:(void (^) (NSString *msg))failure;

+ (void)sendHeadImage:(UIImage *)image success:(void (^)(void))success;

@end
