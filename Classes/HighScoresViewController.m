//
//  HighScoresViewController.m
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 8/21/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//     
//  due to reuse, 'difficulty' is read as setName  
//

#import "HighScoresViewController.h"
#import "Wordz1_2ViewController.h"  // new 100821
#import "SoundEffect.h" 
#import "Constants.h"

@implementation HighScoresViewController

@synthesize delegate;

@synthesize num1Label, num2Label, num3Label, num4Label, num5Label,
num6Label, num7Label, num8Label, num9Label, num10Label;

@synthesize initials1Label, initials2Label, initials3Label, initials4Label, initials5Label,
initials6Label, initials7Label, initials8Label, initials9Label, initials10Label;

@synthesize difficulty1Label, difficulty2Label, difficulty3Label, difficulty4Label, difficulty5Label,
difficulty6Label, difficulty7Label, difficulty8Label, difficulty9Label, difficulty10Label;

@synthesize score1Label, score2Label, score3Label, score4Label, score5Label,
score6Label, score7Label, score8Label, score9Label, score10Label;

@synthesize  doneButton, highScoresFilename;  //clearScoresButton,

// loadScores start 

- (void)loadScores:(NSString *)filename {
	[self clearTable];
//	NSLog(@"in loadScores...wint filename %@", filename);
	
	// highScoresFilename = filename;
	
	NSString *scoreString = [[NSString alloc] initWithContentsOfFile:filename];
	if ([scoreString length] == 0) {
//		NSLog(@"Looked for file %@ but not found.", highScoresFilename);
        [scoreString release];        // 110323
		[self clearTable];
		return;
	}
	
//	NSLog(@"Found file, contents are >\n%@<.", scoreString);
	
	NSArray *rows = [scoreString componentsSeparatedByString:@"\n"];
	NSEnumerator *enumerator = [rows objectEnumerator];
	id element;
	int count = 0;
	while ((element = [enumerator nextObject])) {
		NSString *str = (NSString *)element;
		NSArray *values = [str componentsSeparatedByString:@":"];
		if ([values count] < 3) {
			continue;
		}
		count++;
		switch (count) {
			case 1:
				[initials1Label setText:[values objectAtIndex:0]];
				[difficulty1Label setText:[values objectAtIndex:1]];
				[score1Label setText:[values objectAtIndex:2]];
				break;
			case 2:
				[initials2Label setText:[values objectAtIndex:0]];
				[difficulty2Label setText:[values objectAtIndex:1]];
				[score2Label setText:[values objectAtIndex:2]];
				break;
			case 3:
				[initials3Label setText:[values objectAtIndex:0]];
				[difficulty3Label setText:[values objectAtIndex:1]];
				[score3Label setText:[values objectAtIndex:2]];
				break;
			case 4:
				[initials4Label setText:[values objectAtIndex:0]];
				[difficulty4Label setText:[values objectAtIndex:1]];
				[score4Label setText:[values objectAtIndex:2]];
				break;
			case 5:
				[initials5Label setText:[values objectAtIndex:0]];
				[difficulty5Label setText:[values objectAtIndex:1]];
				[score5Label setText:[values objectAtIndex:2]];
				break;
			case 6:
				[initials6Label setText:[values objectAtIndex:0]];
				[difficulty6Label setText:[values objectAtIndex:1]];
				[score6Label setText:[values objectAtIndex:2]];
				break;
			case 7:
				[initials7Label setText:[values objectAtIndex:0]];
				[difficulty7Label setText:[values objectAtIndex:1]];
				[score7Label setText:[values objectAtIndex:2]];
				break;
			case 8:
				[initials8Label setText:[values objectAtIndex:0]];
				[difficulty8Label setText:[values objectAtIndex:1]];
				[score8Label setText:[values objectAtIndex:2]];
				break;
			case 9:
				[initials9Label setText:[values objectAtIndex:0]];
				[difficulty9Label setText:[values objectAtIndex:1]];
				[score9Label setText:[values objectAtIndex:2]];
				break;
			case 10:
				[initials10Label setText:[values objectAtIndex:0]];
				[difficulty10Label setText:[values objectAtIndex:1]];
				[score10Label setText:[values objectAtIndex:2]];
				break;
			default:
				break;
		}
	}
    
    [scoreString release];        // 110323	
//	[self highlightScore:0];
//	NSLog(@"Do see scores? .... ");

}

// loadScores end


/*
- (IBAction)clearScores:(id)sender {
	NSLog(@"in Clear Scores...");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Clear Scores" 
													message:@"Are you sure you want to clear\nthe high scores?"
												   delegate:self 
										  cancelButtonTitle:@"No" 
										  otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}
 */

/*
- (void) alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger) index {
	if (index == 0) {
		NSLog(@"buttonIndex is 0..");
		
//		[self clearScores2];
	}
	if (index == 1) {
		NSLog(@"buttonIndex is 1.. with highScoresFilename of <skip>."); // , highScoresFilename
		// start clear2 routine right here
		NSString *str = @"";
		[str writeToFile:highScoresFilename atomically:YES encoding:NSUnicodeStringEncoding error:nil];
//		[self clearTable];
		if (clearScoresSound == nil) {
			NSBundle *mainBundle = [NSBundle mainBundle];
			clearScoresSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"SPLATIT" ofType:@"WAV"]];
		}
		NSLog(@"Got splatt sound... ");
		[clearScoresSound play];
		
		// end clear2 routine
//		[self clearScores2];
	}
	
}

*/

/*
- (void)clearScores2 {
	NSLog(@"in Clear Scores2...");
	NSString *str = @"";
	[str writeToFile:highScoresFilename atomically:YES encoding:NSUnicodeStringEncoding error:nil];
	[self clearTable];
	if (clearScoresSound == nil) {
		NSBundle *mainBundle = [NSBundle mainBundle];
		clearScoresSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"SPLATIT" ofType:@"WAV"]];
	}
	NSLog(@"Got splatt sound... ");
	[clearScoresSound play];
}
*/

// ClearTable  start

- (void) clearTable {
//	NSLog(@"In Clear Table... ");
	
	[initials1Label setText:@"---"];
	[difficulty1Label setText:@"------------------"];
	[score1Label setText:@"---"];
	
	[initials2Label setText:@"---"];
	[difficulty2Label setText:@"------------------"];
	[score2Label setText:@"---"];
	
	[initials3Label setText:@"---"];
	[difficulty3Label setText:@"------------------"];
	[score3Label setText:@"---"];
	
	[initials4Label setText:@"---"];
	[difficulty4Label setText:@"------------------"];
	[score4Label setText:@"---"];
	
	[initials5Label setText:@"---"];
	[difficulty5Label setText:@"------------------"];
	[score5Label setText:@"---"];
	
	[initials6Label setText:@"---"];
	[difficulty6Label setText:@"------------------"];
	[score6Label setText:@"---"];
	
	[initials7Label setText:@"---"];
	[difficulty7Label setText:@"------------------"];
	[score7Label setText:@"---"];
	
	[initials8Label setText:@"---"];
	[difficulty8Label setText:@"------------------"];
	[score8Label setText:@"---"];
	
	[initials9Label setText:@"---"];
	[difficulty9Label setText:@"------------------"];
	[score9Label setText:@"---"];
	
	[initials10Label setText:@"---"];
	[difficulty10Label setText:@"------------------"];
	[score10Label setText:@"---"];
	
	[self highlightScore:0];
}

// ClearTable  end


//    start highlightScore  (no highlighting in Wordz for now)

- (void) highlightScore:(NSInteger) index {
	[initials1Label setTextColor:[UIColor blackColor]];
	[difficulty1Label setTextColor:[UIColor blackColor]];
	[score1Label setTextColor:[UIColor blackColor]];
	[num1Label setTextColor:[UIColor blackColor]];
	[initials2Label setTextColor:[UIColor blackColor]];
	[difficulty2Label setTextColor:[UIColor blackColor]];
	[score2Label setTextColor:[UIColor blackColor]];
	[num2Label setTextColor:[UIColor blackColor]];
	[initials3Label setTextColor:[UIColor blackColor]];
	[difficulty3Label setTextColor:[UIColor blackColor]];
	[score3Label setTextColor:[UIColor blackColor]];			
	[num3Label setTextColor:[UIColor blackColor]];
	[initials4Label setTextColor:[UIColor blackColor]];
	[difficulty4Label setTextColor:[UIColor blackColor]];
	[score4Label setTextColor:[UIColor blackColor]];
	[num4Label setTextColor:[UIColor blackColor]];
	[initials5Label setTextColor:[UIColor blackColor]];
	[difficulty5Label setTextColor:[UIColor blackColor]];
	[score5Label setTextColor:[UIColor blackColor]];
	[num5Label setTextColor:[UIColor blackColor]];
	[initials6Label setTextColor:[UIColor blackColor]];
	[difficulty6Label setTextColor:[UIColor blackColor]];
	[score6Label setTextColor:[UIColor blackColor]];
	[num6Label setTextColor:[UIColor blackColor]];
	[initials7Label setTextColor:[UIColor blackColor]];
	[difficulty7Label setTextColor:[UIColor blackColor]];
	[score7Label setTextColor:[UIColor blackColor]];
	[num7Label setTextColor:[UIColor blackColor]];
	[initials8Label setTextColor:[UIColor blackColor]];
	[difficulty8Label setTextColor:[UIColor blackColor]];
	[score8Label setTextColor:[UIColor blackColor]];
	[num8Label setTextColor:[UIColor blackColor]];
	[initials9Label setTextColor:[UIColor blackColor]];
	[difficulty9Label setTextColor:[UIColor blackColor]];
	[score9Label setTextColor:[UIColor blackColor]];
	[num9Label setTextColor:[UIColor blackColor]];
	[initials10Label setTextColor:[UIColor blackColor]];
	[difficulty10Label setTextColor:[UIColor blackColor]];
	[score10Label setTextColor:[UIColor blackColor]];
	[num10Label setTextColor:[UIColor blackColor]];
	
	switch (index) {
		case 1:
			[initials1Label setTextColor:[UIColor redColor]];
			[difficulty1Label setTextColor:[UIColor redColor]];
			[score1Label setTextColor:[UIColor redColor]];
			[num1Label setTextColor:[UIColor redColor]];
			break;
		case 2:
			[initials2Label setTextColor:[UIColor redColor]];
			[difficulty2Label setTextColor:[UIColor redColor]];
			[score2Label setTextColor:[UIColor redColor]];
			[num2Label setTextColor:[UIColor redColor]];
			break;
		case 3:
			[initials3Label setTextColor:[UIColor redColor]];
			[difficulty3Label setTextColor:[UIColor redColor]];
			[score3Label setTextColor:[UIColor redColor]];			
			[num3Label setTextColor:[UIColor redColor]];
			break;
		case 4:
			[initials4Label setTextColor:[UIColor redColor]];
			[difficulty4Label setTextColor:[UIColor redColor]];
			[score4Label setTextColor:[UIColor redColor]];
			[num4Label setTextColor:[UIColor redColor]];
			break;
		case 5:
			[initials5Label setTextColor:[UIColor redColor]];
			[difficulty5Label setTextColor:[UIColor redColor]];
			[score5Label setTextColor:[UIColor redColor]];
			[num5Label setTextColor:[UIColor redColor]];
			break;
		case 6:
			[initials6Label setTextColor:[UIColor redColor]];
			[difficulty6Label setTextColor:[UIColor redColor]];
			[score6Label setTextColor:[UIColor redColor]];
			[num6Label setTextColor:[UIColor redColor]];
			break;
		case 7:
			[initials7Label setTextColor:[UIColor redColor]];
			[difficulty7Label setTextColor:[UIColor redColor]];
			[score7Label setTextColor:[UIColor redColor]];
			[num7Label setTextColor:[UIColor redColor]];
			break;
		case 8:
			[initials8Label setTextColor:[UIColor redColor]];
			[difficulty8Label setTextColor:[UIColor redColor]];
			[score8Label setTextColor:[UIColor redColor]];
			[num8Label setTextColor:[UIColor redColor]];
			break;
		case 9:
			[initials9Label setTextColor:[UIColor redColor]];
			[difficulty9Label setTextColor:[UIColor redColor]];
			[score9Label setTextColor:[UIColor redColor]];
			[num9Label setTextColor:[UIColor redColor]];
			break;
		case 10:
			[initials10Label setTextColor:[UIColor redColor]];
			[difficulty10Label setTextColor:[UIColor redColor]];
			[score10Label setTextColor:[UIColor redColor]];
			[num10Label setTextColor:[UIColor redColor]];
			break;
		default:
			break;
	}
}

//    highlight Score end

-(IBAction)done {
//	NSLog(@"Here in Done routine for HighScoresViewController.m");
	// got here 
	// another way? :
	[self.delegate highScoresViewControllerDidFinish:self];	// new 100821
	
//	[[self parentViewController] dismissModalViewControllerAnimated:(BOOL)YES]; // not right100821
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 //	self.view.backgroundColor = [UIColor clearColor];
 //	self.view.backgroundColor = [UIColor cyanColor];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	highScoresFilename = @"";
	highScoresFilename = [highScoresFilename stringByAppendingString:documentsDirectory];
	highScoresFilename = [highScoresFilename stringByAppendingString:kHighScoresFileName];
//	NSLog(@"in ViewDidLoad... with filename %@", highScoresFilename);
	
	
	[self loadScores:(highScoresFilename)];

}


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
