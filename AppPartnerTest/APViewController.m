//
//  APViewController.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/2/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import "APViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface APViewController ()
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_apppartner.png"]];
    self.navigationItem.title = @"Main Menu";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    self.spinner.hidden = false;

    [[self spinner] startAnimating];
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {

            [self sessionStateChanged:session state:status error:error];
        }];
    }else{
        [[self spinner] stopAnimating];

        [self performSegueWithIdentifier:@"loginFacebook" sender:self];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    self.spinner.hidden = true;
    [[self spinner] stopAnimating];
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error{
    switch (state) {
        case FBSessionStateOpen:{
            [[self spinner] stopAnimating];
            self.spinner.hidden = true;
            [self performSegueWithIdentifier:@"loginFacebook" sender:self];
        }
            break;
            
        case FBSessionStateClosed:
            [self.navigationController popToRootViewControllerAnimated:YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:fbsessions object:session];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
