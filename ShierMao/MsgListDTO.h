//
//  MsgListDTO.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/7.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgListDTO : NSObject

@property (nonatomic, strong) NSNumber *firstID;
@property (nonatomic, strong) NSNumber *nums;
@property (nonatomic, strong) NSNumber *groupID;

- (instancetype)initWithGroupID:(NSNumber *)groupID firstID:(NSNumber *)firstID nums:(NSNumber *)nums;

@end
