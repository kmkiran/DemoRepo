//
//  ViewController.m
//  FBDemoAPp
//
//  Created by Kiran's on 24/12/14.
//  Copyright (c) 2014 Kiran's. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"public_profile", @"email", @"user_friends",@"user_birthday",@"publish_actions",nil]];
    loginView.frame = CGRectMake((self.view.frame.size.width/2) - 100, 40, 200, 40);
    loginView.delegate = self;
    [self.view addSubview:loginView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    
    _lblName.text = [NSString stringWithFormat:@"User Name - %@",user.name];
    _lblDOB.text  = [NSString stringWithFormat:@"User DOB  - %@",user.birthday];
    _lblGender.text  = [NSString stringWithFormat:@"User is  - %@",[user objectForKey:@"gender"]];
    _btnMoreData.hidden = NO;
    
    [[NSUserDefaults standardUserDefaults] setValue:[user objectForKey:@"id"] forKey:@"FBID"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.lblName.text = @"User Name - No Active User";
    self.lblDOB.text  = @"User DOB  - No Active User";
    self.lblGender.text  = @"No Data";
    _btnMoreData.hidden = YES;
}


@end
