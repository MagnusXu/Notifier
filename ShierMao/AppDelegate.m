//
//  AppDelegate.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "AppDelegate.h"
#import "SUMNavigationController.h"
#import "FirstOpenVC.h"

#import "MainPageTableVC.h"
#import "PersonVC.h"
#import "CommentVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) SUMNavigationController *rootNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UINavigationBar appearance].barTintColor = GLOBAL_BG_COLOR;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0]};
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([USER_DEFAULT objectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY]) {
        MainPageTableVC *openVC = [MainPageTableVC new];
        self.rootNav = [[SUMNavigationController alloc] initWithRootViewController:openVC];
    } else {
        FirstOpenVC *openVC = [FirstOpenVC new];
        self.rootNav = [[SUMNavigationController alloc] initWithRootViewController:openVC];
    }
    
    self.window.rootViewController = self.rootNav;
    [self.window makeKeyAndVisible];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    
    return YES;
}

- (void)setRootVC2MainPage {
    MainPageTableVC *mainVC = [MainPageTableVC new];
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.rootNav.viewControllers];
    [vcArray replaceObjectAtIndex:0 withObject:mainVC];
    [self.rootNav setViewControllers:[vcArray copy]];
    [self.rootNav popToRootViewControllerAnimated:YES];
}

- (void)setRootVC2FirstOpen {
    FirstOpenVC *FOVC = [FirstOpenVC new];
    self.rootNav = [[SUMNavigationController alloc] initWithRootViewController:FOVC];
    self.window.rootViewController = self.rootNav;
    [self.window makeKeyAndVisible];
}

@end
