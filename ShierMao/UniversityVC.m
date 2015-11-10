//
//  UniversityVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/10/11.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "UniversityVC.h"
#import "RegistDTO.h"
#import "UniversityInfo.h"
#import "WebServiceClient.h"
#import "AppDelegate.h"

@interface UniversityVC ()

@property (nonatomic, strong) NSArray *list;

@end

@implementation UniversityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [WebServiceClient fetchUniversityListWithSuccess:^(NSArray *ary){
        self.list = ary;
        [self.tableView reloadData];
    } failure:^(NSString *msg){
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = ((UniversityInfo *)self.list[indexPath.row]).name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.registDTO.universityID = ((UniversityInfo *)self.list[indexPath.row]).universityID;
    [WebServiceClient registWithRegistDTO:self.registDTO
                                  success:^{
                                      [APP_DELEGATE setRootVC2MainPage];
                                  } failure:^(NSString *msg){
                                      [SVProgressHUD showInfoWithStatus:msg];
                                  }];

}

@end
