//
//  UserDetailsViewController.h
//  FBDemoAPp
//
//  Created by Kiran's on 26/12/14.
//  Copyright (c) 2014 Kiran's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface UserDetailsViewController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate>

{
    CLLocationManager *locationManger;
    
    UILongPressGestureRecognizer *longPress;
}

@property (weak, nonatomic) IBOutlet UIButton *btnGetLocation;

@property (weak, nonatomic) IBOutlet UIView *viewLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;

@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;

@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLoader;

@property (weak, nonatomic) IBOutlet UIView *viewLoader;

-(IBAction)showLocation:(id)sender;

@end
