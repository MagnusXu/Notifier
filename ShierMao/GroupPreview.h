//
//  GroupPreview.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/9.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupPreview : NSObject

@property (nonatomic, strong) NSNumber *groupID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *universityID;
@property (nonatomic, strong) NSNumber *memberCount;
@property (nonatomic, strong) NSNumber *level;

@end
