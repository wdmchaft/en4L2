//
//  DemoViewController.m
//  en4L2
//
//  Created by Harry Layman on 9/21/11.
//  Copyright 2011 NewportCoastSoftware. All rights reserved.
//

#import "DemoViewController.h"
#import "Wordz1_2ViewController.h"
#import "Constants.h"



@implementation DemoViewController

@synthesize  delegate;
@synthesize  doneButton;


/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */


- (void)dealloc
{
    [super dealloc];
    [doneButton release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    // Do any additional setup after loading the view from its nib.
    // add movie
    // example:   correctSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"BLOOP" ofType:@"WAV"]];
	
    NSString *url = [[NSBundle mainBundle]
                     pathForResource:@"WL-demo-06" ofType:@"m4v"];   // halprog hardcoded movie name. 110919
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(movieFinishedCallback:)     
     name:MPMoviePlayerPlaybackDidFinishNotification 
     object:player];
    
    //--set the size of the movie view and then add it to the View window--
    player.view.frame = CGRectMake(84, 100, 600, 457); [self.view addSubview:player.view];
    //--play movie--
    [player play];
    
    [super viewDidLoad];    
    // add movie end
    
    
}

// also add for movie

- (void) movieFinishedCallback:(NSNotification*) aNotification { 
    MPMoviePlayerController *moviePlayer = [aNotification object]; 
    [[NSNotificationCenter defaultCenter]
     
     removeObserver:self 
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:moviePlayer]; 
    
    [moviePlayer.view removeFromSuperview];
    [player release];
}

// end also add for movie

- (IBAction) done {
    //		NSLog(@"Here in Done routine for AboutWLViewController.m");
	// got here 
	
	/*
     if (([theMMTextField.text isEqualToString: @"PP"]) ||
     ([theMMTextField.text isEqualToString: @"WP"]))  {
     mmSetting = theMMTextField.text;
     [[NSUserDefaults standardUserDefaults] setObject:mmSetting forKey:kGameMode];
     }
     
     if (([thePLTextField.text isEqualToString: @"CN"]) ||
     ([thePLTextField.text isEqualToString: @"EN"])) {
     plSetting = thePLTextField.text;
     [[NSUserDefaults standardUserDefaults] setObject:plSetting forKey:kLangToTest];
     }
     */ 
	//  [[NSUserDefaults standardUserDefaults] setInteger:lives forKey:kLivesKey];
	
	
	//	NSLog(@"Here in Done routine for HighScoresViewController.m");
	// got here 
	// another way? :
	// [self.delegate highScoresViewControllerDidFinish:self];	// new 100821
	
	//	[[self parentViewController] dismissModalViewControllerAnimated:(BOOL)YES]; // not right100821
	//  [self.delegate settingsViewControllerDidFinish:self];	
    
    
	[self.delegate demoViewControllerDidFinish:self];	
	
}		




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
