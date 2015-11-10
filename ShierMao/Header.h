//
//  Header.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#ifndef ShierMao_Header_h
#define ShierMao_Header_h

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define ACCESS_TOKEN_USER_DEFAULT_KEY   @"access_token_user_default_key"
#define USER_INFO_USERNAME_DEFAULT_KEY @"user_info_username_key"
#define USER_INFO_GENDER_DEFAULT_KEY @"user_info_gender_key"
#define USER_INFO_GRADE_DEFAULT_KEY @"user_info_grade_key"
#define USER_INFO_ID_DEFAULT_KEY @"user_info_id_key"
#define USER_INFO_DESC_DEFAULT_KEY @"user_info_desc_key"
#define USER_INFO_ROLE_DEFAULT_KEY @"user_info_role_key"
#define USER_INFO_NAME_DEFAULT_KEY @"user_info_name_key"
#define USER_INFO_STUID_DEFAULT_KEY @"user_info_stu_id_key"
#define USER_INFO_UNIVERSITY_ID_DEFAULT_KEY @"user_info_university_id_key"
#define USER_INFO_UNIVERSITY_NAME_DEFAULT_KEY @"user_info_university_name_key"
#define USER_INFO_HEAD_IMAGE @"user_info_head_image"
#define USER_INFO_HEAD_IMAGE_URL @"user_info_head_image_url"
#define COLLECTED_MSG_ARY @"collected_msg_ary"

#define UIColorFromHex(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]
#define UIColorWithRGB(r,g,b)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define GLOBAL_BG_COLOR UIColorWithRGB(0,187,213)
#define GLOBAL_DETAIL_COLOR UIColorFromHex(0x9B9B9B)
#define GLOBAL_TEXT_COLOR UIColorFromHex(0x303030)
#define GLOBAL_T_COLOR UIColorFromHex(0x212121)
#define GLOBAL_CELL_BTN_COLOR UIColorFromHex(0x636363)

#define GLOBAL_T_FONT 24
#define GLOBAL_HEAD_FONT 18
#define GLOBAL_DERAIL_FONT 14

#endif