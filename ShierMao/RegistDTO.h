//
//  RegistDTO.h
//  ShierMao
//
//  Created by 孙铭 on 15/10/9.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistDTO : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSNumber *studentID;
@property (nonatomic, strong) NSNumber *universityID;

@end
