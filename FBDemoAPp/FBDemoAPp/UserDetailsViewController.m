//
//  UserDetailsViewController.m
//  FBDemoAPp
// This view is used for getting and sharing User Current Location
//  Created by Kiran's on 26/12/14.
//  Copyright (c) 2014 Kiran's. All rights reserved.
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewLocation.hidden = YES;
    _viewLoader.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showLocation:(id)sender
{
    locationManger = [[CLLocationManager alloc]init];

    locationManger.delegate = self;
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locationManger respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManger requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManger  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }

    locationManger.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManger.distanceFilter = 500; // meters

    [locationManger startUpdatingLocation];

    _viewLocation.hidden = NO;
    _viewLoader.hidden = NO;

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    
    [_imgViewLoader.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *altError = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [altError show];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _viewLoader.hidden = YES;
    
    NSLog(@"Location = %@",locations);
    
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    longPress.minimumPressDuration = 1.0f;
    longPress.allowableMovement = 100.0f;
    
    [_viewLocation addGestureRecognizer:longPress];

    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    _lblLatitude.text = [NSString stringWithFormat:@"Latitude :- %.8f",currentLocation.coordinate.latitude];
    
    _lblLongitude.text = [NSString stringWithFormat:@"Longitude :- %.8f",currentLocation.coordinate.longitude];

    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
//         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];

             placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             NSString *strAdd = nil;
             
             if ([placemark.subThoroughfare length] != 0)
                 strAdd = placemark.subThoroughfare;
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strAdd = placemark.thoroughfare;
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
                 else
                     strAdd = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                 else
                     strAdd = placemark.locality;
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
                 else
                     strAdd = placemark.administrativeArea;
             }
             
             if ([placemark.country length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
                 else
                     strAdd = placemark.country;
             }
             
             _txtViewAddress.text = strAdd;
             
             _imgViewLoader.hidden = YES;

         }
     }];
}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:longPress])
    {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User Location" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share User Location", @"Close", nil];
            
            alertView.delegate = self;
            
            [alertView show];
        }
    }

}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_viewLocation setHidden:YES];
            break;
          
        case 1:
        {

            NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
            
            NSString *wallPost = _txtViewAddress.text;
            
            [fbArguments setObject:wallPost forKey:@"message"];
            
            NSString *strFBID = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBID"];
            
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/feed",strFBID] parameters:fbArguments HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
            {
                if (!error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Location details posted successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                }

            }]; //requestWithGraphPath:@"me/feed" andParams:fbArguments andHttpMethod:@"POST"                               andDelegate:self];

        }
            break;

        default:
            break;
    }}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
