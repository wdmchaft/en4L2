    //
//  SettingsViewController.m
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//     
//  figure out how to see what is available to this view controller in terms of instance variables on the mail app view controller..
//

#import "SettingsViewController.h"
#import "Wordz1_2ViewController.h"
#import "Constants.h"

@implementation SettingsViewController

@synthesize delegate, mmSetting, plSetting, sidxSetting, useAlphaSetting, preventEMSetting ;

#pragma mark -
#pragma mark View life cycle


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

//  Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	self.view.backgroundColor = [UIColor clearColor];
//	self.view.backgroundColor = [UIColor redColor];
	
	// other default avlue changes / loading?
	// oh  get user settings to initialize lables:
	
	/*
	 
	 
	NSLog(@"\n\n\tHere in viewDidLoad routine for SettingsViewController.m\n");	

	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kGameMode]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:@"WP"
		 forKey:kGameMode];
		theMMTextField.text = @"WP";
	}
	else {
		theMMTextField.text = [[NSUserDefaults standardUserDefaults]
						stringForKey:kGameMode];
		
	}
	 */
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kLangToTest]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:@"CN"
		 forKey:kLangToTest];
		thePLTextField.text = @"CN";
	}
	else {
		thePLTextField.text = [[NSUserDefaults standardUserDefaults]
							   stringForKey:kLangToTest];
		
	}
	
	
//	NSLog(@"I am here... ");
	
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kSetToUse]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:1 
		 forKey:kSetToUse];
		theSIDXTextfield.text = @"1";
// 		gSetIDX = 1;
	}
	else {
		int holdInt = [[NSUserDefaults standardUserDefaults]
								 integerForKey:kSetToUse];

		NSString *holdSIDX = [[NSString alloc] initWithFormat: @"%d",holdInt];
		theSIDXTextfield.text = holdSIDX;		
		[holdSIDX release];

	}
	
//	NSLog(@"I am here 2... ");


	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kUseAlpha]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:0 
		 forKey:kUseAlpha];
         useAlphaSetting = 0; // 110416
        
//		NSLog(@"NO default value for alpha found; setting to zero.");
		// 		gSetIDX = 1;
	}
	else {
		int holdInt2 = [[NSUserDefaults standardUserDefaults]
					   integerForKey:kUseAlpha];
		useAlphaSetting = holdInt2;
        
        // set position of switch1 based on value of alpha at load...
        if (useAlphaSetting) {   // means is true is 1 is noflip so switch1 or FlipSwitch should be off
            [flipSwitch setOn:NO animated:YES];
            
        } else {
            [flipSwitch setOn:YES animated:YES];
        
        }
        
	//				NSLog(@"Default value for alpha found: %d.", holdInt2);
	
		
	}
	
// new
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kPreventEM]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:0 
		 forKey:kPreventEM];
		preventEMSetting = 0;
        //		NSLog(@"NO default value for preventEM; setting to zero.");
		// 		gSetIDX = 1;
	}
	else {
		int holdInt3 = [[NSUserDefaults standardUserDefaults]
                        integerForKey:kPreventEM];
		
		preventEMSetting = holdInt3;	
        
        if (preventEMSetting) {   // means is true is 1 is noEM so AllowEM Switch should be off
            [allowEMSwitch setOn:NO animated:YES];
            
        } else {
            [allowEMSwitch setOn:YES animated:YES];
            
        }

        
        
        
        //				NSLog(@"Default value for alpha found: %d.", holdInt3);
		
		
	}
	
//    NSLog(@"finishing in viewdid load of settings view controller.m ;-).."); // 110420 
// doh! can't see that...   NSLog(@" First set name is: %@.", setNM[1]);
    
    
    
//end new    
	
}
#pragma mark -
#pragma mark texFields

// next two routines are NOOPs... from text...
// adding back 11-03-09 due to two text fields re-added: set and alpha

-(BOOL)textFieldShouldBeginEditing: (UITextField *) textField {
	[textField setReturnKeyType:UIReturnKeyNext];
	return YES;
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
	[textField resignFirstResponder];
	return YES;
}


-(void) textFieldDidEndEditing: (UITextField *)textField {
	// test for which text field was updated 
	// wordsOfWisdom = textField.text;

//	NSLog(@"Did end editing");
//	NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);		
	
//  won't save values until after DONE is pressed...	
//	if (! [[theSIDXTextfield.text] isEqualToString: @"" ])
		
	
	

	//	NSLog(@"text field name is: %@, obj id: %@.", textField.Label, textField.ObjectID);

/*	
if (([theMMTextField.text isEqualToString: @"W2W"]) ||
	([theMMTextField.text isEqualToString: @"W2P"])) 
	mmSetting = theMMTextField.text;

if (([thePLTextField.text isEqualToString: @"EN"]) ||
	([thePLTextField.text isEqualToString: @"CN"]))
	plSetting = thePLTextField.text;	
	
*/
}

#pragma mark -
#pragma mark Controls



-(IBAction) changeAEMSwitch: (id) sender{
    if (allowEMSwitch.on) { 
        preventEMSetting = 0;
    }
    else { 
        preventEMSetting = 1;
    }
    
    
}



-(IBAction) changeFlipSwitch: (id) sender{
    
    if (flipSwitch.on) { 
        useAlphaSetting = 0;
    }
    else { 
        useAlphaSetting = 1;
    }
}

-(IBAction)done {
//	NSLog(@"Here in Done routine for SettingsViewController.m");
// got here 
/*	
if (([theMMTextField.text isEqualToString: @"PP"]) ||
	([theMMTextField.text isEqualToString: @"WP"]) || 
	([theMMTextField.text isEqualToString: @"WW"]) ) 
	  {  // 
		mmSetting = theMMTextField.text;
		  	NSLog(@"\tWrote out mm as: %@", mmSetting);	
	[[NSUserDefaults standardUserDefaults] setObject:mmSetting forKey:kGameMode];
}
	
if (([thePLTextField.text isEqualToString: @"CN"]) ||
	([thePLTextField.text isEqualToString: @"EN"])) {
		plSetting = thePLTextField.text;
		NSLog(@"\tWrote out PL as: %@", plSetting);	
	[[NSUserDefaults standardUserDefaults] setObject:plSetting forKey:kLangToTest];
}
*/
	
	// if index not 1 to 16 set to 1
	
	
	int sIDX = [theSIDXTextfield.text intValue]; // intValue returns 0 for invalid string.
	if ((sIDX < 1) || (sIDX > 16)) {
		sIDX = 1;
	}
	
	

//	NSLog(@"sIDX as: %d.   KILO", sIDX);	

	
	if ((sIDX > 0)  && ( sIDX < 17)) {             // 110309 change to 17 from 4?  but check above means i don't need this.
		sidxSetting = sIDX;
		
		// 110309 again, do this back in main view controller...
		/*  
		[[NSUserDefaults standardUserDefaults] setInteger:sIDX forKey:kSetToUse];
		NSLog(@"\n\tWrote out sidx as: %d", sidxSetting);	
		*/
	}
	
//	int sUA = [theUseAlphaTextfield.text intValue];  // will be zero for illegal string
//	int pEM = [preventEMTextfield.text intValue];    // will be zero for illegal string    
	
//	NSLog(@"sUA as: %d.   LIMA", sUA);	
	
	
    
    

  /*
    if (pEM > 0)  { // 
		preventEMSetting = 1;
	} else {
		preventEMSetting = 0;
	}

    */
    
	// always write back out 
	// this is NOT done in the examples, so i will suspend it for now..110309 changes to not do this here... 
	
	
    [[NSUserDefaults standardUserDefaults] setInteger:useAlphaSetting forKey:kUseAlpha];
    
//		NSLog(@"Wrote out useAlpha as: %d.   MILAN", sUA); //useAlphaSetting);	
		  
//    [[NSUserDefaults standardUserDefaults] setInteger:pEM forKey:kPreventEM];
    
    
   [[NSUserDefaults standardUserDefaults] setInteger:preventEMSetting forKey:kPreventEM];    

	
	 
	
	
//	[[NSUserDefaults standardUserDefaults] setInteger:gSetIDX forKey:kSetToUse];

	
//  [[NSUserDefaults standardUserDefaults] setInteger:lives forKey:kLivesKey];
//  by calling delegate all the time, might be extra overhead. could not call delgate if values invalid etc. 
	
//  NSLog(@"Next is call to settingsViewControllerDidFinish delegate...\n");

[self.delegate settingsViewControllerDidFinish:self];	

}		
					   
					   
#pragma mark ORientation and Memory management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
			(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
//    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
