//
//  ViewController.h
//  FBDemoAPp
//
//  Created by Kiran's on 24/12/14.
//  Copyright (c) 2014 Kiran's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *lblName;

@property (nonatomic, weak) IBOutlet UILabel *lblDOB;

@property (weak, nonatomic) IBOutlet UILabel *lblGender;

@property (weak, nonatomic) IBOutlet UIButton *btnMoreData;

@end

