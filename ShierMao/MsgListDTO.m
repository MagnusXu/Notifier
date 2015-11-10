//
//  MsgListDTO.m
//  ShierMao
//
//  Created by 孙铭 on 15/10/7.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "MsgListDTO.h"

@implementation MsgListDTO

- (instancetype)initWithGroupID:(NSNumber *)groupID firstID:(NSNumber *)firstID nums:(NSNumber *)nums {
    self = [super init];
    if (self) {
        self.groupID = groupID;
        self.firstID = firstID;
        self.nums = nums;
    }
    return self;
}

@end
