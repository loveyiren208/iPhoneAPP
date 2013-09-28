//
//  APDanceViewController.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/2/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import "APDanceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#define characterCount 6
#define tiltDegree 0.25

@interface APDanceViewController (){
    AVAudioPlayer *backgroundMusicPlayer;
    CMMotionManager *motionManager;
    Boolean ifDance;
    Boolean ready;
    Boolean tilt;
    SystemSoundID characterSound;
}
@property (strong, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) IBOutlet UIImageView *characterImage;
- (IBAction)dance:(id)sender;

@end

@implementation APDanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set up character image
    [self setRandomCharacter];
    
    //set up background music
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    NSURL *backgroundMusicURL =[NSURL fileURLWithPath:backgroundMusicPath];
    NSError *error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [backgroundMusicPlayer setNumberOfLoops:-1];
    [backgroundMusicPlayer setVolume:0.5];
    [backgroundMusicPlayer prepareToPlay];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_apppartner.png"]];

    //init value
    ifDance = false;
    ready = false;
    tilt = false;
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [motionManager stopAccelerometerUpdates];
    tilt = false;
}

//ready to dance. set up Accelerometer, music and character
- (IBAction)dance:(id)sender {
    if(ready == false){
        ready = true;
        [self setUpAccelerometer];
        [backgroundMusicPlayer play];
    }
}

//if tilt. character will jump
-(void)setUpAccelerometer{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                            
                                            if (fabs(accelerometerData.acceleration.x) >= tiltDegree) {
                                                tilt = true;
                                                if(ifDance == false){
                                                    ifDance = TRUE;
                                                    [self moveUp];
                                                }
                                            }else{
                                                tilt = false;
                                            }
                                            
                                            if (error) {
                                                NSLog(@"%@",error);
                                            }
                                        }];
}

//character move up. if tilt is false,return, else move uo and then move down
-(void)moveUp{
    if(!tilt){
        ifDance = false;
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(moveDown)];
    CGRect up = self.characterImage.frame;
    up.origin.y -=50;
    self.characterImage.frame = up;
    NSLog(@"moveup");
    
    [UIView commitAnimations];
}

//play the character sound. move down and then move up
-(void)moveDown{
    
    AudioServicesPlaySystemSound(characterSound);
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(moveUp)];
    CGRect up = self.characterImage.frame;
    up.origin.y +=50;
    self.characterImage.frame = up;
    NSLog(@"moveDown");
    
    [UIView commitAnimations];
    
}

// random select one character and sound
-(void)setRandomCharacter{
    //set up chatacter image
    int num = arc4random()%characterCount;
    NSString *name = [[NSString alloc] initWithFormat:@"%d.png",num];
    UIImage *character = [UIImage imageNamed:name];
    [[self characterImage] setImage:character];
    
    //set up character sound
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    NSString *ref = [NSString stringWithFormat:@"%d",num/2];
    CFURLRef sound = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)ref,CFSTR("caf"), NULL);
    AudioServicesCreateSystemSoundID(sound, &characterSound);
    
}

//check if press the character. if so select one new character to dance
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    CGRect characterRect = [self.characterImage frame];
    if(CGRectContainsPoint(characterRect, touchLocation)){
        [self setRandomCharacter];
    }
}
@end
