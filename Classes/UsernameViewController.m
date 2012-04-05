    //
//  UsernameViewController.m
//  wl2
//
//  Created by Harry Layman on 12/23/10.
//  Copyright 2010 NewportCoastSoftware. All rights reserved.
//

#import "UsernameViewController.h"
#import "Wordz1_2ViewController.h"
#import "Constants.h"

@implementation UsernameViewController
@synthesize delegate, wlUserName ;
#pragma mark -
#pragma mark View Life Cycle




 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];
	//	self.view.backgroundColor = [UIColor clearColor]; // --> may be for slider not included so just comment out. 101219
//	self.view.backgroundColor = [UIColor cyanColor];
	
	
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kLastUserName]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:@"AAA"
		 forKey:kLastUserName];
		theUserNameField.text = @"AAA";
	}
	else {
		theUserNameField.text = [[NSUserDefaults standardUserDefaults]
								 stringForKey:kLastUserName];
	}
}
#pragma mark -
#pragma mark TextField


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[textField setReturnKeyType:UIReturnKeyNext];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldDidEndEditing: (UITextField *)textField {
	wlUserName = textField.text;
	return YES;
}

#pragma mark -
#pragma mark Controls 

- (IBAction) done {
	
//	NSLog(@"Here in Done routine for UsernameViewController.m");
	
	//	if (! [theUserNameField.text isEqualToString: @"" ])
	//		userName = theUserNameField.text;
	
	if (! [theUserNameField.text isEqualToString: @""]) 
	{  
		wlUserName = theUserNameField.text;
//		NSLog(@"\n\n\tWrote out wlusername as: %@", wlUserName);	
		[[NSUserDefaults standardUserDefaults] setObject:wlUserName forKey:kLastUserName];
	}
	
	[self.delegate usernameViewControllerDidFinish:self];
}



#pragma mark -
#pragma mark orientation




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
			(interfaceOrientation == UIInterfaceOrientationLandscapeRight));

    // Overriden to allow any orientation.
//    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
