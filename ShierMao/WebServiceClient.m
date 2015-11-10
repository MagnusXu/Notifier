//
//  WebServiceClient.m
//  ShierMao
//
//  Created by 孙铭 on 15/10/7.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "WebServiceClient.h"
#import <AFNetworking.h>

#import "LoginDTO.h"
#import "RegistDTO.h"
#import "TokenDTO.h"
#import "UserInfo.h"
#import "MsgListDTO.h"
#import "ReplyDTO.h"
#import "MsgC.h"
#import "MsgD.h"
#import "GroupPreview.h"
#import "Reply.h"
#import "UniversityInfo.h"
#import <UIImageView+AFNetworking.h>

static NSString * const baseURLString = @"http://115.28.65.29:3000/api/";

static NSString *kErrorMsg = @"网络错误, 请稍后再试";
static NSString *kStatus = @"status";

@implementation WebServiceClient

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"image/jpeg"];
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sessionManager.reachabilityManager startMonitoring];
    });
    if (!sessionManager.reachabilityManager.isReachable && sessionManager.reachabilityManager.networkReachabilityStatus != AFNetworkReachabilityStatusUnknown) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络连接已断开", nil)];
        return nil;
    }
    return sessionManager;
}

+ (BOOL)isNetWorkAvailable {
    return [self sessionManager].reachabilityManager.isReachable;
}

+ (NSString *)synthesizedURLStringWithString:(NSString *)str usingAccessToken:(BOOL)use{
    NSString *res = [NSString stringWithFormat:@"%@%@", baseURLString, str];
    if (use) {
        NSString *accessToken = [USER_DEFAULT stringForKey:ACCESS_TOKEN_USER_DEFAULT_KEY];
        res = [res stringByAppendingFormat:@"?token=%@", accessToken];
    }
    return res;
}

+ (void)registWithRegistDTO:(RegistDTO *)dto
                    success:(void (^) ())success
                    failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Login/regist";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"username": dto.username,
                                                 @"password": dto.password,
                                                 @"name": dto.name,
                                                 @"gender": dto.gender,
                                                 @"student_id": dto.studentID,
                                                 @"university_id": dto.universityID}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                                
                                TokenDTO *token = [TokenDTO new];
                                token.key = respondObject[@"token"];
                                NSDictionary *user = respondObject[@"user"];
                                
                                [USER_DEFAULT setObject:user[@"username"] forKey:USER_INFO_USERNAME_DEFAULT_KEY];
                                [USER_DEFAULT setObject:token.key forKey:ACCESS_TOKEN_USER_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"gender"] forKey:USER_INFO_GENDER_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"grade"] forKey:USER_INFO_GRADE_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"id"] forKey:USER_INFO_ID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"name"] forKey:USER_INFO_NAME_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"role"] forKey:USER_INFO_ROLE_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"desc"] forKey:USER_INFO_DESC_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"student_id"] forKey:USER_INFO_STUID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"university_id"] forKey:USER_INFO_UNIVERSITY_ID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"university"][@"name"] forKey:USER_INFO_UNIVERSITY_NAME_DEFAULT_KEY];
                                
                                success();
                            } else if ([respondObject[kStatus] isEqual:@2]) {
                                [SVProgressHUD showErrorWithStatus:@"该账号已被注册"];
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)fetchUniversityListWithSuccess:(void (^)(NSArray *ary))success failure:(void (^) (NSString *msg))failure {
    NSString *url = @"University/getList";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:nil
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                NSArray *array = [respondObject[@"data"] bk_map:^id(id obj){
                                    UniversityInfo *university = [UniversityInfo new];
                                    university.universityID = obj[@"id"];
                                    university.name = obj[@"name"];
                                    return university;
                                }];
                                success(array);
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"错误"];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)loginWithLoginDTO:(LoginDTO *)dto
                  success:(void (^) ())success
                  failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Login/login";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"username": dto.username, @"password": dto.password}
                        success:^(NSURLSessionDataTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                TokenDTO *token = [TokenDTO new];
                                token.key = respondObject[@"token"];
                                NSDictionary *user = respondObject[@"user"];
                                
                                [USER_DEFAULT setObject:user[@"username"] forKey:USER_INFO_USERNAME_DEFAULT_KEY];
                                [USER_DEFAULT setObject:token.key forKey:ACCESS_TOKEN_USER_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"gender"] forKey:USER_INFO_GENDER_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"grade"] forKey:USER_INFO_GRADE_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"id"] forKey:USER_INFO_ID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"name"] forKey:USER_INFO_NAME_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"role"] forKey:USER_INFO_ROLE_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"desc"] forKey:USER_INFO_DESC_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"student_id"] forKey:USER_INFO_STUID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"university_id"] forKey:USER_INFO_UNIVERSITY_ID_DEFAULT_KEY];
                                [USER_DEFAULT setObject:user[@"university"][@"name"] forKey:USER_INFO_UNIVERSITY_NAME_DEFAULT_KEY];
                                NSString *imageUrl = user[@"img_url"];
                                if (imageUrl) {
                                    [USER_DEFAULT setObject:imageUrl forKey:USER_INFO_HEAD_IMAGE_URL];
                                    UIImageView *imageV = [UIImageView new];
                                    [imageV setImageWithURL:[NSURL URLWithString:imageUrl]];
                                }
                                success();
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        }failure:^(NSURLSessionDataTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
    
}

+ (void)fetchMyGroupsWithSuccess:(void (^) (NSArray *ary))success
                         failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Group/getMyGroups";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]} success:^(NSURLSessionTask *task, id respondObject){
        if ([respondObject[kStatus] isEqual:@0]) {
            NSArray *array = respondObject[@"data"];
            success(array);
        } else {
            [SVProgressHUD showErrorWithStatus:@"错误"];
        }
    } failure:^(NSURLSessionTask *task, NSError *error){
        if (failure) {
            failure(kErrorMsg);
        }
    }];
}

+ (void)fetchMsgListWithGroupID:(MsgListDTO *)dto
                        success:(void (^) (NSArray *msgList))success
                        failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Msg/getList";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"group_id": dto.groupID,
                                                 @"first_id": dto.firstID,
                                                 @"nums": dto.nums,
                                                 @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject) {
                            if ([respondObject[kStatus] isEqual:@0]) {
                                NSArray *respondArray = [respondObject[@"data"] bk_map:^id (NSDictionary *obj){
                                    MsgC *aMsgc = [MsgC new];
                                    aMsgc.title = obj[@"title"];
                                    aMsgc.preview = obj[@"preview"];
                                    aMsgc.readCount = obj[@"read_count"];
                                    aMsgc.ID = obj[@"id"];
                                    aMsgc.addTime = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)((NSNumber *)obj[@"add_time"]).intValue];
                                    return aMsgc;
                                }];
                                success(respondArray);
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error) {
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)fetchMsgDetailWithMsgID:(NSNumber *)msgID
                        success:(void (^) (MsgD *msgDetail))success
                        failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Msg/getDetail";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"msg_id": msgID, @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                MsgD *msgDetail = [MsgD new];
                                msgDetail.msgID = respondObject[@"id"];
                                msgDetail.msgType = respondObject[@"msg_type"];
                                msgDetail.title = respondObject[@"title"];
                                msgDetail.groupID = respondObject[@"group_id"];
                                msgDetail.userID = respondObject[@"user_id"];
                                msgDetail.bodyType = respondObject[@"body_type"];
                                msgDetail.preview = respondObject[@"preview"];
                                msgDetail.hitsCount = respondObject[@"hits_count"];
                                msgDetail.readCount = respondObject[@"read_count"];
                                msgDetail.replyCount = respondObject[@"reply_count"];
                                msgDetail.bodyHTML = respondObject[@"body"];
                                msgDetail.read = [(NSNumber *)respondObject[@"read"] isEqualToNumber:@1] ? YES : NO;
                                msgDetail.addTime = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)respondObject[@"add_time"]).intValue];
                                
                                UserInfo *user = [UserInfo new];
                                msgDetail.user = user;
                                NSDictionary *userDic = respondObject[@"user"];
                                
                                user.name = userDic[@"name"];
                                user.username = userDic[@"username"];
                                user.desc = userDic[@"desc"];
                                user.gender = userDic[@"gender"];
                                user.university_id = userDic[@"university_id"];
                                user.iD = userDic[@"id"];
                                user.role = userDic[@"role"];
                                user.imgUrl = userDic[@"img_url"];
                                
                                success(msgDetail);
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        }failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)fetchReplyListWithMsgID:(ReplyDTO *)dto
                        success:(void (^) (NSArray *replyList))success
                        failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Msg/getReplies";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"msg_id": dto.msgID, @"last_id": dto.lastID, @"nums": dto.nums, @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                NSArray *replyList = [respondObject[@"data"] bk_map:^id(id obj){
                                    Reply *rep = [Reply new];
                                    rep.iD = obj[@"id"];
                                    rep.msgID = obj[@"msg_id"];
                                    rep.userID = obj[@"user_id"];
                                    rep.body = obj[@"body"];
                                    rep.replyTime = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)obj[@"reply_time"]).intValue];
                                    NSDictionary *userDic = obj[@"user"];
                                    UserInfo *user = [UserInfo new];
                                    user.name = userDic[@"name"];
                                    user.username = userDic[@"username"];
                                    user.desc = userDic[@"desc"];
                                    user.gender = userDic[@"gender"];
                                    user.university_id = userDic[@"university_id"];
                                    user.iD = userDic[@"id"];
                                    user.role = userDic[@"role"];
                                    user.imgUrl = userDic[@"img_url"];
                                    
                                    rep.user = user;
                                    
                                    return rep;
                                }];
                                success(replyList);
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)sendReplyWithMsgID:(NSNumber *)msgID
                      body:(NSString *)body
                   success:(void (^) ())success
                   failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Msg/reply";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"msg_id": msgID, @"body": body, @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                success();
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"错误"];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
    
}

+ (void)sendReadWithMsgID:(NSNumber *)msgID success:(void (^) ())success {
    NSString *url = @"Msg/readToggle";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"msg_id": msgID, @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                success();
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            [SVProgressHUD showErrorWithStatus:kErrorMsg];
                        }];
}

+ (void)fetchGourpPreviewWithGroupID:(NSInteger *)groupID
                             Success:(void (^) (GroupPreview *preview))success
                             failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Group/getPreview";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"group_id": [NSString stringWithFormat:@"%ld", (long)groupID], @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject) {
                            if ([respondObject[kStatus] isEqual:@0]) {
                                GroupPreview *groupPreview = [GroupPreview new];
                                groupPreview.groupID = respondObject[@"id"];
                                groupPreview.name = respondObject[@"name"];
                                groupPreview.desc = respondObject[@"desc"];
                                groupPreview.universityID = respondObject[@"university_id"];
                                groupPreview.memberCount = respondObject[@"member_count"];
                                groupPreview.level = respondObject[@"level"];
                                
                                success(groupPreview);
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"错误"];
                            }
                        }failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)searchGroupWithGroupName:(NSString *)groupName
                         success:(void (^) (NSArray *ary))success
                         failure:(void (^) (NSString *msg))failure {
    NSString *url = @"Group/search";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"name": groupName, @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                NSArray *ary = [respondObject[@"data"] bk_map:^id(id obj){
                                    GroupPreview *groupPreview = [GroupPreview new];
                                    groupPreview.name = obj[@"group"][@"name"];
                                    groupPreview.desc = obj[@"group"][@"desc"];
                                    groupPreview.groupID = obj[@"group_id"];
                                    groupPreview.universityID = obj[@"group"][@"university_id"];
                                    groupPreview.memberCount = obj[@"group"][@"member_count"];
                                    groupPreview.level = obj[@"level"];
                                    return groupPreview;
                                }];
                                success(ary);
                            } else {
                                [SVProgressHUD showErrorWithStatus:respondObject[@"reason"]];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            if (failure) {
                                failure(kErrorMsg);
                            }
                        }];
}

+ (void)applySentWithGroupID:(NSNumber *)groupID body:(NSString *)body {
    NSString *url = @"Group/apply";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url parameters:@{@"group_id": groupID,
                                                 @"body": body,
                                                 @"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
                        success:^(NSURLSessionTask *task, id respondObject){
                            if ([respondObject[kStatus] isEqual:@0]) {
                                [SVProgressHUD showSuccessWithStatus:@"申请提交成功"];
                            } else if ([respondObject[kStatus] isEqual:@2]) {
                                [SVProgressHUD showErrorWithStatus:@"您已在群组里"];
                            } else {
                                [SVProgressHUD showInfoWithStatus:@"请等待管理员处理"];
                            }
                        } failure:^(NSURLSessionTask *task, NSError *error){
                            [SVProgressHUD showErrorWithStatus:kErrorMsg];
                        }];
}

+ (void)sendHeadImage:(UIImage *)image success:(void (^)(void))success {
    NSString *url = @"User/uploadImg";
    url = [self synthesizedURLStringWithString:url usingAccessToken:NO];
    [[self sessionManager] POST:url
                      parameters:@{@"token": [USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]}
       constructingBodyWithBlock:^(id formdata){
           NSDateFormatter *formatter = [NSDateFormatter new];
           [formatter setDateFormat:@"yyyyMMddHHmmss"];
           NSString *name = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
           [formdata appendPartWithFileData:UIImageJPEGRepresentation(image, 0.2) name:@"img" fileName:name mimeType:@"img/jpg"];
       } success:^(NSURLSessionTask *task, id respondObject){
           if ([respondObject[kStatus] isEqual:@0]) {
               [USER_DEFAULT setObject:UIImagePNGRepresentation(image) forKey:USER_INFO_HEAD_IMAGE];
               success();
           } else {
               [SVProgressHUD showErrorWithStatus:@"上传失败"];
           }
       } failure:^(NSURLSessionTask *task, NSError *error){
           [SVProgressHUD showErrorWithStatus:kErrorMsg];
       }];
}

@end