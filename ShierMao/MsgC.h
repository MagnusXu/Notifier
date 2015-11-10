//
//  MsgC.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/7.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgC : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *preview;
@property (nonatomic, strong) NSNumber *readCount;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSDate *addTime;

@property (nonatomic, strong) NSNumber *rowIndex;

@end
