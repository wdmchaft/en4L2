//
//  Wordz1_2AppDelegate.m
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//     
// 110828 gestures do this to set default swipe value  3.05

#import "Wordz1_2AppDelegate.h"
#import "Wordz1_2ViewController.h"

@implementation Wordz1_2AppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // 110828 gestures do this to set default swipe value 
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"NO" forKey:@"enableSwipes"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    

    
	// Override point for customization after app launch. 
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
//	srand(time(NULL)); // random seed  no longer needed with arc4random()

    // sleep(10); // for splash screen
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
