//
//  APServerPingViewController.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/2/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import "APServerPingViewController.h"

@interface APServerPingViewController (){
    NSMutableData *receiveData;
    NSDate *start;
}
@property (strong, nonatomic) IBOutlet UILabel *responseLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIImageView *popup;
- (IBAction)ping:(id)sender;

@end

@implementation APServerPingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_apppartner.png"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ping:(id)sender {
    receiveData = [[NSMutableData alloc] init];
    
    self.spinner.hidden = false;
    [[self spinner] startAnimating];
    
    start = [NSDate date];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-243-205-92.compute-1.amazonaws.com/Tests/ping.php"]
                                                              cachePolicy:NSURLCacheStorageNotAllowed
                                                          timeoutInterval:20.0];
    
    [theRequest setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *bodyData = @"Password=EGOT";
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    [connection start];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receiveData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *respondBody = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    NSString *reponseString = [[NSString alloc] initWithFormat:@"Response: %@",respondBody];
    [[self responseLabel] setText:reponseString];
    
    [[self spinner] stopAnimating];
    self.spinner.hidden = true;
    
    double time = [[NSDate date] timeIntervalSinceDate:start];
    NSString *ping = [[NSString alloc] initWithFormat:@"Pint Time: %.2fms",time*1000];
    [[self timeLabel] setText:ping];
    
    
    self.timeLabel.hidden = false;
    self.responseLabel.hidden = false;
    self.popup.hidden = false;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[self responseLabel] setText:@"Time Out"];
    
    [[self spinner] stopAnimating];
    self.spinner.hidden = true;
    
    NSString *ping = [[NSString alloc] initWithFormat:@""];
    [[self timeLabel] setText:ping];
    
    
    self.timeLabel.hidden = false;
    self.responseLabel.hidden = false;
    self.popup.hidden = false;
}

@end
