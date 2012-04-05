//
//  Wordz1_2ViewController.m
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//
//  database file name from Constants.h
/*

110913 add review mode button image swap.  part way done...  halprog
110921 begin pause state re-sync fix 110921 
       if paused :   [incorrectSound play];                   //110921



 
*/ 
 ////////////
/*
 

 make sure board size fix is in, luneets de sol in fr database, time is temps on FR screen, etc.
 
 then add korean 3.03
 
 
 */

#import <QuartzCore/QuartzCore.h>
#import "Wordz1_2ViewController.h"
#import "Constants.h"
#import "SoundEffect.h"

@implementation Wordz1_2ViewController

@synthesize statusLabel;
@synthesize timeLabel;
@synthesize missedLabel;
@synthesize modeLabel;            //110208


@synthesize pauseButton;
@synthesize topScoresButton;
@synthesize clearScoresButton;
@synthesize nxwGameButton;
@synthesize hintButton;               // 101202
@synthesize nextSetButton;
@synthesize nextStyleButton;
@synthesize nextLangButton;

@synthesize setReviewModeButton;      //101228

@synthesize setUsernameButton;

@synthesize wordzSetLabelNM;

@synthesize fcImageView;
@synthesize imageView200x200;       //110828  gestures 

@synthesize correctSound, incorrectSound, winnerSound, nxwGameSound, hintSound, highScoreSound; // 101223 note hintSound
@synthesize timer;

@synthesize highScoreFilename, highScoreTitle, lastInitials;

#pragma mark -
#pragma mark Misc stuff
 
// Load sound files into SoundEffect objects, and hold on to them for later use
- (void)setupSounds {
//		NSLog(@"in setup sound.");
		NSBundle *mainBundle = [NSBundle mainBundle];
	
	//    tickSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tick" ofType:@"caf"]];
	//    tockSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tock" ofType:@"caf"]];
		
	 correctSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"BLOOP" ofType:@"WAV"]];
	 incorrectSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"BHUMP" ofType:@"WAV"]];
	 winnerSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"AKINALO" ofType:@"WAV"]];
	 nxwGameSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"BLIP2" ofType:@"WAV"]];
	 highScoreSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"NEOSOUND" ofType:@"WAV"]];
	
	 hintSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"ZINC" ofType:@"WAV"]]; //101216
	
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];

	self.highScoreFilename = @"";
	self.highScoreFilename = [self.highScoreFilename stringByAppendingString:documentsDirectory];
	self.highScoreFilename = [self.highScoreFilename stringByAppendingString:kHighScoresFileName];
	
	isClearing = FALSE;
    
	// And set up images:  (PE_CHANGE_ONLY)  addded 110913 to ipad
    
    
    resumeImage = [UIImage imageNamed: @"b-ResumeRestartGreen.png"];
    pauseImage  = [UIImage imageNamed: @"b-Pause_stopwatch.png"];
    
    reviewImage = [UIImage imageNamed: @"b-Study-Learn-C4.png"];
    playImage   = [UIImage imageNamed: @"b-Play-c.png"];
    
    

	 
	 } // setupSounds 

- (void) setupDatabase {                          //100905
// copy database, get ready to access 
//	NSLog(@"In setupDatabase routine.... ");
// 	databaseName = kDatabaseNameFR4EN;                  //100915   database name is in Constants.h  110714 NEEDS 
//  databaseName set in viewDidLoad -- swithching UI requires restart    
    
    
	hasLoadedDB = FALSE;						  //100911   will insure we read Setz and Tilez from db once.
    
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	// -- instead do this for each new game.  [self readAnimalsFromDatabase];
//	NSLog(@"leaving setupDatabase routine.... ");	
	}  // setupDatabase


- (void) checkAndCreateDatabase { 
	//
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
//	NSLog(@"In checkAndCreateDatabase routine.... ");

	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSLog(@"\n\ncopy of db in documents folder is at %@\n==\n", databasePath);
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	// success = FALSE; // force new copy +++++++++++>>>> sest back debug change!!!
	
	// If the database already exists then return without doing anything
	// we could check the version and overwrite it if it is old!!! 100905 hal
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];

//	NSLog(@"\n\ncopy of db at source in bundel is at %@\n===\n", databasePathFromApp);

	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
//	[fileManager release];	
	
//	NSLog(@"leaving checkAndCreateDatabase...");
	
	}  // checkAndCreateDatabase




- (void)timerMethod:(NSTimer *)theTimer {
	time++;
/*
	NSString *timeText = [[NSString alloc] initWithFormat:@"%d", time ];
	timeLabel.text = timeText;
	[timeText release];
*/	
	timeLabel.text = [ NSString stringWithFormat: @"%d", time ];
	
/*
 
 this is a leak?
 
 timeLabel.text = [ NSString stringWithFormat: @"%d", time ];

 
 
 so try:
 
 	NSString *timeText = [[NSString alloc] initWithFormat:@"%d", time ];
 
 
 */
	
	
	
//	NSLog(@"In timer function at %d", time);
} // end of timerMethod

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

#pragma mark -
#pragma mark Top Level Control 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
// get user preferences or set them if they are not saved
	//  matchMode is  PP or WP or CC
	//  pictureLang is EN or CN --> change for version 3.00!!
    //  110715 halprog
	
    /* version 3.0  110715  
    
    Set initial UI language. 
    
    for now hard code to debug.
     
     setNM[mm] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement0,1)];
    
     
     NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
     
    */
    
//    k_L1 = [[NSMutableString alloc] initWithString: kL1]; // temp halprog -> set in case statement below
     
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    ////////////////////
    /*
       
     */  
    ////////////////////    
    //  gestures 110828   read in value.. set in app delegate..
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bEnableSwipes  = [defaults boolForKey:@"enableSwipes"];    
    
    if (bEnableSwipes == TRUE) {
        //        NSLog(@" Swipes enabled...");
        kEnableSwipes = 1;
    }
    else {
        
        kEnableSwipes = 0;
        //        NSLog(@"No swipes....");
    }
    

    
    NSLog(@"Device currently set to language >%@<.", language);
//    NSLog(@"We will get setnames using  NOT %@ as L2 language", kL2); // 110810b
    
    if ([language isEqualToString: @"en"]) { 
//        NSLog(@"We have ENGLISH...");
        databaseName = kDatabaseNameL24EN;
        k_L1 = @"EN";
        // this is okay        
    }
    else if ([language isEqualToString: @"es"]) {     
//        NSLog(@"We have SPANISH...");
        databaseName = kDatabaseNameL24ES;
        k_L1 = @"ES"; 
    }
    else if ([language isEqualToString: @"zh-Hans"]) {     
//        NSLog(@"We have CHINESE...");
        databaseName = kDatabaseNameL24CN;        
        k_L1 = @"CN";
     }
    else if ([language isEqualToString: @"zh-Hant"]) {     
//        NSLog(@"We have CHINESE...");
        databaseName = kDatabaseNameL24CN;        
        k_L1 = @"CN";
        // this is not yet avail
        // put up alert saying "not yet done; using english UI"
    }
    else if ([language isEqualToString: @"de"]) {     
//        NSLog(@"We have GERMAN...");
        databaseName = kDatabaseNameL24DE;        
//        [k_L1 initWithString:@"DE"];        wrong :-)
        k_L1  = @"DE";                
    }

    else if ([language isEqualToString: @"fr"]) {     
//        NSLog(@"We have FRENCH...");
         databaseName = kDatabaseNameL24FR;
        k_L1 = @"FR";
    }
//   
    else if ([language isEqualToString: @"ko"]) {     
        //        NSLog(@"We have FRENCH...");
        databaseName = kDatabaseNameL24KR;
        k_L1 = @"KR";
        }
//    
    else if ([language isEqualToString: @"ja"]) {     // Japanese is ja :-)
        //        NSLog(@"We have japanese...");
        databaseName = kDatabaseNameL24JP;        
        k_L1  = @"JP";                
    }
    else if ([language isEqualToString: @"it"]) {     
//        NSLog(@"We have ITALIAN...");
        databaseName = kDatabaseNameL24IT;
        k_L1 = @"IT"; 

    }
    else {
//        NSLog(@"Unknown language %@ found.", language);
        databaseName = kDatabaseNameL24EN;
        k_L1 = @"EN"; 
        
        // put up alert saying
        //        "unknown language; only DE, ES, CN, IT supported -- using english"
    }
    
//    NSLog (@"k_L1 is set to >%@.", k_L1);    
    
    pictureLang = k_L1; // ver 300 110717 halprog
    
    
    /*
    switch (language) {
        case @"en";
            NSLog(@"We have ENGLISH...");
            // this is okay
            break;
        case @"es";
            NSLog(@"We have SPANISH...");
            // this is not yet avail
            // put up alert saying "not yet done; using english"
            break;    
        case @"zh";
            NSLog(@"We have CHINESE...");
            // this is not yet avail
            // put up alert saying "not yet done; using english"
            break;    
        case @"de";
            NSLog(@"We have GERMAN...");
            // this is okay
           break;
        case @"fr";
            NSLog(@"We have FRENCH...");
            // this is okay
            break;
        case @"it";
            NSLog(@"We have ITALIAN...");
            // this is okay
            break;
            
        default:
            NSLog(@"Unknown language %@ found.", language);
            // this is not yet avail
            // put up alert saying
            //        "unknown language; only DE, ES, CN, IT supported -- using english"
            break;    
            
            break;
    }
    
    */
        
    
    
//    [language release];

//    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];

// i18n localized strings -- put them all here.    
    
	pauseState = 0; // set to "Pause" lable to start
    
/*	pauseString = @"Pause";
   	resumeString = @"Resume";
	easyString = @"Review";                                 //101228
	noEasyString = @"Play";                                 //101228 
*/    
    
    pauseString = NSLocalizedString(@"PAUSE", nil);
  	resumeString = NSLocalizedString(@"RESUME", nil);
	easyString = NSLocalizedString(@"REVIEW", nil);    
	noEasyString = NSLocalizedString(@"PLAY", nil);  
    usernamePt1String  = NSLocalizedString(@"USERNAMESETP1", nil);  
    usernamePt2String  = NSLocalizedString(@"USERNAMESETP2", nil);
    gamePausedString  = NSLocalizedString(@"GAMEPAUSED", nil);
    yesAisBString = NSLocalizedString(@"YESAISB", nil);
    sorryAnotBneedCString = NSLocalizedString(@"SORRYANOTBNEEDC", nil);
    sorryNOEMString = NSLocalizedString(@"SORRYNOEM", nil);
    endReviewGameString = NSLocalizedString(@"ENDREVIEWGAME", nil);
    endOfGameMessageString = NSLocalizedString(@"ENDOFGAMEMSG", nil);
    wlClearScoresHDRString = NSLocalizedString(@"WLCLEARSCORES", nil);
    wlScoresRClearedString = NSLocalizedString(@"SCORESCLEARED", nil);
    doneString = NSLocalizedString(@"DONE", nil);
    wlAskClearScoresString = NSLocalizedString(@"ASKCLEARSCORES", nil);
    cancelString  = NSLocalizedString(@"CANCEL", nil);
    OKString  = NSLocalizedString(@"OK", nil);

// no hints
    
        flipDuration = 0.3; // 110903
    
    
    

      noExactMatchAllowedMsg = NSLocalizedString(@"NOEMAMSG", nil);  
//    noExactMatchAllowedMsg = @" No Exact Matches (words to words, pics to pics) is enabled.";  // 1103406
    
    
// get from settings	useAlpha = 0 ;							//110309 flip, don't fade, by default
	
	hasLoadedDB = FALSE;
	
	[super viewDidLoad];
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kLastUserName]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:@"AAA"
		 forKey:kLastUserName];
		lastInitials = @"AAA";
	}
	else {
		lastInitials  = [[NSUserDefaults standardUserDefaults]
						 stringForKey:kLastUserName];
	}
//	NSLog(@"\nAt start (viewdidload), lastInitials = %@.", lastInitials);
	
	
	
	/*
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kGameMode]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:@"WP"
		 forKey:kGameMode];
		matchMode = @"WP";
	}
	else {
		matchMode = [[NSUserDefaults standardUserDefaults]
					 stringForKey:kGameMode];
	}
	NSLog(@"\nAt start (viewdidload), matchMode = %@.", matchMode);
	*/
	matchMode = @"WP";
//	NSLog(@"\nAt start (viewdidload), matchMode force to %@.", matchMode); // 101202 remove ability to start in other than WP mode.
	
	//
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kLangToTest]) {
		[[NSUserDefaults standardUserDefaults]
		 setObject:kL2
		 forKey:kLangToTest];
		pictureLang = kL2;
//         [pictureLang initWithString:kL2];
        
        
	}
	else {
		pictureLang = [[NSUserDefaults standardUserDefaults]
					 stringForKey:kLangToTest];
		
	}
	
    
    if (![pictureLang isEqualToString: k_L1]) {
//         set it to kL1
        pictureLang = k_L1;
        
    }
    
    
    
//	NSLog(@"\nAt start, FC pictureLang = %@.", pictureLang);
// halprog version 3.00  fix pictureLang 	-> changed to L1? why not hardcode to FR aka kL2?  hmm.. 
	//
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kSetToUse]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:1 
		 forKey:kSetToUse];
		gSetIDX = 1;
	}
	else {
		gSetIDX = [[NSUserDefaults standardUserDefaults]
					   integerForKey:kSetToUse];
		
	}
	// 
	
	// 110309  
	//   this will check and set useAlpha setting - default to zero or flip
	
//	NSLog(@"\nAt start, FC pictureLang = %@.", pictureLang);

	//
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kUseAlpha]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:0 
		 forKey:kUseAlpha];
		useAlpha = 0;
	}
	else {
		useAlpha = [[NSUserDefaults standardUserDefaults]
				   integerForKey:kUseAlpha];
		
	}
	//  end of new useAlpha code 
    
// new preventEM code
	if (![[NSUserDefaults standardUserDefaults]
		  objectForKey:kPreventEM]) {
		[[NSUserDefaults standardUserDefaults]
		 setInteger:0 
		 forKey:kPreventEM];
		preventEM = 0;
	}
	else {
		preventEM = [[NSUserDefaults standardUserDefaults]
                    integerForKey:kPreventEM];
		
	}
	
    // end of new preventEM code    

    ////////////////////
    
    if (![[NSUserDefaults standardUserDefaults]
          objectForKey:@"LL"]) {
        [[NSUserDefaults standardUserDefaults]
         setObject:@"DEFAULT"
         forKey:@"LL"];
        LLString = @"DEFAULT";
    }
    else {
        LLString  = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"LL"];
    }
    
    
    NSLog(@"We have value for LL of: %@", LLString);
    
    // make sure valid
    if (([LLString isEqualToString: @"EN"]) ||
        ([LLString isEqualToString: @"ES"]) ||
        ([LLString isEqualToString: @"ZH"]) ||
        ([LLString isEqualToString: @"KR"]) ||
        ([LLString isEqualToString: @"JP"]) ||                  

        ([LLString isEqualToString: @"DE"]) ||
        ([LLString isEqualToString: @"FR"]) ||
        ([LLString isEqualToString: @"IT"]) ||
        ([LLString isEqualToString: @"DEFAULT"]))
    {
        // NSLog value
        
    } else {
        LLString = @"DEFAULT";
    }
    
    /*  not used now.
    if (![[NSUserDefaults standardUserDefaults]
          objectForKey:@"LX"]) {
        [[NSUserDefaults standardUserDefaults]
         setObject:@"DEFAULT"
         forKey:@"LX"];
        LXString = @"DEFAULT";
    }
    else {
        LXString  = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"LX"];
    }
    
    
    NSLog(@"We have value for LX of: %@", LXString);    
    */
    //////////////////// 
    
    /*
     
     if LLString is not "DEFAULT"
     
     set database based on LLSTring Value
     
     
     */
    
    
    
    if ([LLString isEqualToString: @"EN"]) { 
        //        NSLog(@"L1 tiles to ENGLISH...");
        databaseName = kDatabaseNameL24EN;
        k_L1 = @"EN";
        // this is okay        
    }
    else if ([LLString isEqualToString: @"ES"]) {     
        //        NSLog(@"L1 tiles to SPANISH...");
        databaseName = kDatabaseNameL24ES;
        k_L1 = @"ES"; 
    }
    else if ([LLString isEqualToString: @"CN"]) {     
        //        NSLog(@"L1 tiles to CN CHINESE...");
        databaseName = kDatabaseNameL24CN;        
        k_L1 = @"CN";
    }
    else if ([LLString isEqualToString: @"ZH"]) {     
        //        NSLog(@"L1 tiles to ZH CHINESE...");
        databaseName = kDatabaseNameL24CN;        
        k_L1 = @"CN";
    }
    else if ([LLString isEqualToString: @"KR"]) {     
        //        NSLog(@"L1 tiles to ZH CHINESE...");
        databaseName = kDatabaseNameL24KR;        
        k_L1 = @"KR";
    }
    else if ([LLString isEqualToString: @"JP"]) {     
        //        NSLog(@"L1 tiles to Japanese...");
        databaseName = kDatabaseNameL24JP;        
        k_L1  = @"JP";                
    }        
    
    else if ([LLString isEqualToString: @"DE"]) {     
        //        NSLog(@"L1 tiles to GERMAN...");
        databaseName = kDatabaseNameL24DE;        
        //        [k_L1 initWithString:@"DE"];        wrong :-)
        k_L1  = @"DE";                
    }
    
    else if ([LLString isEqualToString: @"FR"]) {     
        //        NSLog(@"L1 tiles to FRENCH...");
        databaseName = kDatabaseNameL24FR;
        k_L1 = @"FR";
    }
    
    else if ([LLString isEqualToString: @"IT"]) {     
        //        NSLog(@"L1 tiles to ITALIAN...");
        databaseName = kDatabaseNameL24IT;
        k_L1 = @"IT"; 
    }
    
    pictureLang = k_L1;  // fix. make sure get pics and words on startup after L1 change.
    
    //////////////////// end of setting L1 language tiles.    
    // viewDidLoad -- add gesture recognition 110828  BEGIN
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTapGesture:)];
    
    //initWithTarget:imageView200x200 action:@selector(handleTapGesture:)];    
    
    tapGesture.numberOfTapsRequired = 2; 
    [imageView200x200 addGestureRecognizer:tapGesture]; 
    [tapGesture release];    
    
    // start swipe gesture 110828 
    
    //---right swipe (default)---
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipeGesture:)];
    
    [imageView200x200 addGestureRecognizer:swipeGesture]; [swipeGesture release];
    //---left swipe---
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleSwipeGesture:)];
    
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [imageView200x200 addGestureRecognizer:swipeLeftGesture];
    [swipeLeftGesture release];    
    
    // viewDidLoad -- add gesture recognition 110828  END    
    
    
    
//	NSLog(@"\nAt start, gSetIDX = %d.\n\n", gSetIDX);
	
	//	NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);		
	
	[self setupSounds];
//	NSLog(@"Done Setup sounds, now setup Database...");
	[self setupDatabase];
	
//	NSLog(@"Done Setup databse, now createNewGame...");
	
	easyFLAG = 0; // NOT EASY -- set to 1 for easy / debug purposes -- but have review mode, so no need. but start in play mode.. 
	firstGame = TRUE;
	
	[self createNewGame];
	
}


// Actual tap gesture Handler  110828  BEGIN
-(IBAction) handleTapGesture:(UIGestureRecognizer *) sender { 
    

    if (kEnableSwipes) {
        
        //    NSLog(@"Got a doubletap.... "); 
        [hintSound play];
        
        [self createNewGame];
    }
}

// Actual Tap Gesture Handler  110828  END


// swipe gesture handler 110828  BEGIN

-(IBAction) handleSwipeGesture:(UIGestureRecognizer *) sender { 
    UISwipeGestureRecognizerDirection direction =
    [(UISwipeGestureRecognizer *) sender direction];
    
    
    //  exit if swipes not enabled...
    
    if (kEnableSwipes) {
        
        
        switch (direction) { 
            case UISwipeGestureRecognizerDirectionUp:
                //            NSLog(@"up...");
                break; 
            case UISwipeGestureRecognizerDirectionDown:
                //            NSLog(@"down...");
                break; 
            case UISwipeGestureRecognizerDirectionLeft:
                //                    NSLog(@"Left..."); 
                [hintSound play];
                [self nextMode];
                break; 
            case UISwipeGestureRecognizerDirectionRight:
                //                    NSLog(@"Right... ");
                [hintSound play];
                [self nextSet];
                break; 
            default:
                break;
                
        }
    } // swipes enabled
}


// swipe gesture handler 110828  END




#pragma mark -
#pragma mark Game Setup -- Init data 

-(void)initializeData {
    /*
 	 NSLog(@"start initializeData ... once per game ? ... ");
	 NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
	*/
	//	first define set level data; one each of several vars:
	// this should be done for every new game when choice of tile set is changed
	// so just do every time...
	// 
	

	// 100905 DBCHANGE   now set array elements from WTilez table -- step 1
	/*
	    when this is working we will change as follows:
		get 'active' set names for user selection; default to set 1 -- 
			this must be done in se/set user choices; get GLOBAL CURRENT SET NUMBER
		initilize array below based on GLOBAL CURRENT SET NUMBER
	 
	*/
	//	initialize static data for tiles 0 - 35;  
	//	
	//  tileIDX[0] = 0, etc for 0 to 35 -- no need to store.
	
	// for setID == 1 just get set data from db
	
	// Setup the database object
	// only do this once per "game" -- so if hasLoadedDB -s FALSE do it, else it just reload using current SetIDX

	
if (!hasLoadedDB) {
	
	
	tileBackPicImageNM = @"tileback_01.jpg";//   hard coded tile back pic. try animation later.
	
	imageBack = [UIImage imageNamed:tileBackPicImageNM];
	
	sqlite3 *database;
//	NSLog(@"Now to open database connection... ===============>\n\n");
	
	// Init the animals Array
	// animals = [[NSMutableArray alloc] init]; -- my arrays exist (see below)
	
	
	// READ IN ALL THE SETZ from the database ========START==============================100911=========>>>>>>>>>>>>>>>>>>

    
    //110717 version 3.0 set names in non French UI are in L1 of WSetz database
    //110810 changes to dynamically determin set title -- use new constant.h value  kL2SetLangID
    
    
    /*
     
     
     Existing code checks for set names with hardcoded  WordzSetNameL1 in WSetz, 
            resulting in two different Databases for
            IT4EN and EN4IT, even through the WTilez tables can be identical and 
            the WSetz table just needs L1 and L2 reversed.
     
     plan: change initializeData routine to check using constant.h value of #define kL2 to 
     figure out which of wordzSetNameL1 or wordzSetNameL2 to use.
     
     Note: use language that is NOT kL2 since kL2 is what they are learning, not what they know!! 110810
     
     want to do after we know either 
        CCC:   select setID, WordzSetNameL1 from WSetz where SetStatus = 'A';
     or
        DDD:   select setID, WordzSetNameL2 from WSetz where SetStatus = 'A';
     
     -- firs we must get the counts as follows, using kL2 where it shows "EN"
     
     select count(*) from WSetz where WordzSetLangL1 = 'EN' and SetStatus = 'A';
     resumt = 16
     
     select count(*) from WSetz where WordzSetLangL2 = 'EN' and SetStatus = 'A';
     result = 0
     
     net result to code: change sql stmt to use NSStrings, to creat *char, so we can then
        dynmically build a sql statement to get the two counts, then choose which column to get set names from.
     
     
     note -- for now will can set up both selects, and conditionally execute only 1!!!  (CCC or DDD)
     later we could build the stmt dynamically as we do both AAA and BBB.
     
     note that for FR4xx or FR4en,  ror example, L1 is EN and L2 is FR. 
            FR count is for setlang1 is say 0, and for setlang2 is say 16. 
            this would mean to use setlang1 since they are LEARNING set lang 2 (FR).
     
     */
    
    //110810 changes to dynamically determin set title -- use new constant.h value  kL1SetLangID
    int numRowsL1, numRowsL2; // number rows for each language.
    // if numRowsL1 < numRowsL2 use L1, else use L2 (one will be zero, the other, 16).
    // first get numb of rows     
    // -- 
    // THIS IS BLOCK TO GET numRowsL1  AAA BEGIN   
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
    // Setup the SQL Statement and compile it for faster access
    // 110810 halprog   note kL2 is quote-en-quote    
        sqlite3_stmt *compiledStatement0;
        
        NSString *newQueryAAA = [NSString stringWithFormat:@"select count(*) from WSetz where WordzSetLangL1 = '%@' and SetStatus = 'A';", kL2];         
//      const char *sqlStatement = "select count(*) from WSetz where WordzSetLangL1 = 'EN' and SetStatus = 'A';"; // 
        const char *sqlStatement = [newQueryAAA UTF8String]; // "select count(*) from WSetz where WordzSetLangL1 = 'EN' and SetStatus = 'A';"; // 
        // halprog change to use konstant once this works. 110810 
       
        // 110810 change to first create NSString so we can substitute different values in the sql stmtnt
        /*
         
         The pattern is: 
         
         sqlite3_stmt    *statement;
         
         NSString *querySQL = @"SELECT address, phone FROM contacts”;
         
         const char *query_stmt = [querySQL UTF8String];
         
         sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL);
         
         
         
         */
        
        
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement0, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            
            //			NSLog(@"Now getting set %d...", mm);
            
            while(sqlite3_step(compiledStatement0) == SQLITE_ROW) {
                // Read the data from the result row
                
                numRowsL1 = sqlite3_column_int(compiledStatement0, 0);
            }
        }
        else {
            NSLog(@"Error with preparing select statement AAA.");
        } 
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement0);
    }
    else {
        NSLog(@"Could not open database!. AAA");
    }
    
    // THIS IS BLOCK TO GET numRowsL1 AAA END
    
    // THIS IS BLOCK TO GET numRowsL2 BBB BEGIN   
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        
        
// 1        const char *sqlStatement = "select count(*) from WSetz where WordzSetLangL2 = 'EN' and SetStatus = 'A';"; // 
        // halprog change to use konstant once this works. 110810 
        sqlite3_stmt *compiledStatement0;
        NSString *newQueryBBB = [NSString stringWithFormat:@"select count(*) from WSetz where WordzSetLangL2 = '%@' and SetStatus = 'A';", kL2];        
        //      const char *sqlStatement = "select count(*) from WSetz where WordzSetLangL1 = 'EN' and SetStatus = 'A';"; // 
        const char *sqlStatement = [newQueryBBB UTF8String]; // "select count(*) from WSetz where WordzSetLangL1 = 'EN' and SetStatus = 'A';"; // 
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement0, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            
            //			NSLog(@"Now getting set %d...", mm);
            
            while(sqlite3_step(compiledStatement0) == SQLITE_ROW) {
                // Read the data from the result row
                
                numRowsL2 = sqlite3_column_int(compiledStatement0, 0);
            }
        }
        else {
            NSLog(@"Error with preparing select statement BBB.");
        } 
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement0);
    }
    else {
        NSLog(@"Could not open database!. BBB");
    }
    
    // THIS IS BLOCK TO GET numRowsL1 BBB END
    
//    NSLog(@"L1 is %@ and L2 is %@.", k_L1, kL2);
    
    // --     
    // now use numRows to get correct set names.     
    if (numRowsL1 < numRowsL2) {   // numrows comarison 222    
        
        // THIS IS BLOCK TO GET wordzSetNameL1s into Array.  CCC BEGIN   
        
//      NSLog(@"Using L1 for set names: L1 / L2 values %d, %d.", numRowsL1, numRowsL2);
        // 110810
        
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            // Setup the SQL Statement and compile it for faster access
            const char *sqlStatement = "select setID, wordzSetNameL1 from WSetz where SetStatus = 'A' "; // identify active sets
            sqlite3_stmt *compiledStatement0;
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement0, NULL) == SQLITE_OK) {
                // Loop through the results and add them to the feeds array
                int mm = 1;
                //			NSLog(@"Now getting set %d...", mm);
                
                while(sqlite3_step(compiledStatement0) == SQLITE_ROW) {
                    // Read the data from the result row
                    
                    setID[mm] = sqlite3_column_int(compiledStatement0, 0);
                    setNM[mm] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement0,1)];
                    
                    //				NSLog(@"We got for idx %d =======>\ncol1: %d \tcol2: %@\n\n", mm, setID[mm], setNM[mm]);
                    mm++;
                    
                    // Add the animal object to the animals Array
                    //[animals addObject:animal];
                    // [animal release];
                }
                mm--;
                //			NSLog(@"finished with jj - found %d sets.", mm); // 100911 store number of setz !
                gMaxSet = mm ;         // note was mm was corrected 							
            }
            else {
                NSLog(@"Error with preparing select statement CCC.");
                
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement0);
            
        }
        else {
            NSLog(@"Could not open database!. ");
            
        }
        
        // THIS IS BLOCK TO GET wordzSetNameL1s into Array.  CCC END
    }   else  {  // numrows comparison 222 -- L2 is the one with Set Names we want 
        // THIS IS BLOCK TO GET wordzSetNameL2s into Array.  DDD BEGIN   
//      NSLog(@"Using L2 for set names: L1 / L2 values %d, %d.", numRowsL1, numRowsL2);  
        // halprog -remove. and for 16 = 16, we don't care!    
        
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            // Setup the SQL Statement and compile it for faster access
            const char *sqlStatement = "select setID, wordzSetNameL2 from WSetz where SetStatus = 'A' "; // identify active sets
            sqlite3_stmt *compiledStatement0;
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement0, NULL) == SQLITE_OK) {
                // Loop through the results and add them to the feeds array
                int mm = 1;
                //			NSLog(@"Now getting set %d...", mm);
                
                while(sqlite3_step(compiledStatement0) == SQLITE_ROW) {
                    // Read the data from the result row
                    
                    setID[mm] = sqlite3_column_int(compiledStatement0, 0);
                    setNM[mm] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement0,1)];
                    
                    //				NSLog(@"We got for idx %d =======>\ncol1: %d \tcol2: %@\n\n", mm, setID[mm], setNM[mm]);
                    mm++;
                    
                    // Add the animal object to the animals Array
                    //[animals addObject:animal];
                    // [animal release];
                }
                mm--;
                //			NSLog(@"finished with jj - found %d sets.", mm); // 100911 store number of setz !
                gMaxSet = mm ;         // note was mm was corrected 							
            }
            else {
                NSLog(@"Error with preparing select statement DDD.");
                
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement0);
            
        }
        else {
            NSLog(@"Could not open database!. ");
            
        }
        
        // THIS IS BLOCK TO GET wordzSetNameL2s into Array.  DDD END   
    }  // end of else block after 222
    
    
    // 	sqlite3_close(database); keep open for next read loop.
	
	
// READ IN ALL THE SETZ from the database ========END================================100911=========>>>>>>>>>>>>>>>>>
	
// READ IN ALL THE Version info from the database ========START  ===============100916=========>>>>>>>>>>>>>>>>>

	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select WordzVNMB, WordzVmodifiedDT, WordzVComment from WordzV "; // identify active sets
		sqlite3_stmt *compiledStatement2;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement2, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			int mm = 1;
//			NSLog(@"Now getting set %d...", mm);
			
			while(sqlite3_step(compiledStatement2) == SQLITE_ROW) {
				// Read the data from the result row
				
				NSString *wVNMB, *wDBDT, *wVCM; // *dbVersionString;
				
				wVNMB = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement2,0)];
				wDBDT = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement2,1)];
				wVCM  = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement2,2)];
				
//     			NSLog(@"We got for dbVer =======>\ncol1: %@ \tcol2: %@ \tcole: %@\n", wVNMB, wDBDT, wVCM);    // debug
				mm++;
				
				NSString *dbVersionString = [NSString stringWithFormat:@"%@|%@|%@|", wVNMB, wDBDT, wVCM];
				
				[[NSUserDefaults standardUserDefaults] setObject:dbVersionString forKey:kDatabaseVersion];
				
//				NSLog(@"\tWrote out databaseVersion as: %@", dbVersionString);	
				[wVNMB release];
                [wDBDT release];
                [wVCM  release];
				
				
				// Add the animal object to the animals Array
				//[animals addObject:animal];
				// [animal release];
			}
			mm--;
//			NSLog(@"finished with jj - found %d V recs.", mm); // 
			
			// save in perfs for future use.
			

		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement2);
		
	}
	
	
// READ IN ALL THE Version info from the database ========END    ===============100916=========>>>>>>>>>>>>>>>>>
	
	
// READ IN ALL THE WTILES from the database ========START==============================100910=========>>>>>>>>>>>>>>>>>>
// version 2.03 -- make image file names lower case.
// version 2.03 -- if checkImageFileName = 1, for all image files try to open and verify they are present. 011118 
//

	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        sqlite3_stmt *compiledStatement;
     
		const char *sqlStatement = "select * from WTilez order by setID, tileID "; // 
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			int jj = 0;
//			NSLog(@"Now getting tile %d...", jj);
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				
		tileLangID_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,2)];
		tileNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,3)];
		wordTXT_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,4)];
				
		pictureIND_db[jj] = sqlite3_column_int(compiledStatement, 5);
				
		matchingTileNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,6)];
				
		matchingTileIDX_db[jj] = sqlite3_column_int(compiledStatement, 7);
				
		tileWordPicImageNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,8)];  // 110118
		tilePicPicImageNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,9)];	  // 110118			
				
//		tileWordPicImageNM_db[jj] = [[[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,8)] lowercaseString];				
//		tilePicPicImageNM_db[jj] = [[[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,9)] lowercaseString];
				
		tileHint_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,13)];		// 101216 try 13 first 

				
/*                
		NSLog(@"We puy into arrays with idx %d =======>\ncol1: %@ \tcol2: %@ \tcol3: %@ \tcol4 %d \ncol5 %@ \tcol6 %d \tcol7 %@ \tcol8 %@\n\n",
					  jj, tileLangID_db[jj], tileNM_db[jj], wordTXT_db[jj], pictureIND_db[jj], 
					  matchingTileNM_db[jj], matchingTileIDX_db[jj], tileWordPicImageNM_db[jj], tilePicPicImageNM_db[jj]
					  );
		NSLog(@"\nHere is hing for tile %@: %d.\t", tileHint_db[jj], jj);
*/
				
		jj++;

				// Add the animal object to the animals Array
		//[animals addObject:animal];
		// [animal release];
			}
			jj--;
//		NSLog(@"finished with file tile jj -- %d", jj);
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);

	// READ IN ALL THE WTILES from the database ========END================================100910=========>>>>>>>>>>>>>>>>>>

	
	
	hasLoadedDB = TRUE;
//	NSLog(@"Now to Close database connection... ===Closed.  ============>\n\n");

	
}
	
	
	
	// END OF DATABASE WORK  -- then set up working arrays! 
	

	// new 2.03 routine to check for existance of all image files in bundle.... 
	/*
	look in here:  tileWordPicImageNM_db[576] and  NSString *tilePicPicImageNM_db[576]

	write out missing tiles to NSLog statements only for now. then must test on device (case issue of filenames)
	 
	 
	
	*/
	
	//	NSString*  missingTileImages = @"Missing tiles are>";   debug9
	
	
	checkImageFileNames = 0; // 110125  <--====== must change this for debug routine to do anything....  
	
	if (checkImageFileNames == 1) {
// routine to put any missing image file names into the nslog file; must be run on device due to lower/upper case issues with OSX and IOS
	NSMutableString *logString = [[NSMutableString alloc] initWithString:@"Missing tilez:"];  	
	
	//	lenS = [logString length]; // save to check at end.
	
	for (int i=0; i <=  575; i++) {
		
		//  NSLog(@"at int is %d", i);
		
		//		NSString* foofile = [documentsPath stringByAppendingPathComponent:tileWordPicImageNM_db[i]];	
		
		NSString *fileLocation = [[NSBundle mainBundle] pathForResource:tileWordPicImageNM_db[i] ofType:@""];		
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:fileLocation]) {
			NSLog(@"Found file %@", tileWordPicImageNM_db[i]); 
		}	else {
			NSLog(@"   No file %@", tileWordPicImageNM_db[i]); 
			
			//	[missingTileImages appendString:tileWordPicImageNM_db[i]];
			[logString appendFormat: @"%@:",tileWordPicImageNM_db[i]]; // added \n 110427
			//
			//		[missingTileImages [NSString stringWithFormat:@"%@>%@:", missingTileImages, tileWordPicImageNM_db[i]];
			
			//			NSLog(@"\n\n\n");
		}
		
		//		fileLocation = @"";
	}
	
	// lenF = [logString length];
	
	for (int i=0; i <=  575; i++) {
		
		//  NSLog(@"at int is %d", i);
		
		//		NSString* foofile = [documentsPath stringByAppendingPathComponent:tilePicPicImageNM_db[i]];	
		
		NSString *fileLocation = [[NSBundle mainBundle] pathForResource:tilePicPicImageNM_db[i] ofType:@""];		
		
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:fileLocation]) {
			NSLog(@"Found file %@", tilePicPicImageNM_db[i]); 
		}	else {
			NSLog(@"   No file %@", tilePicPicImageNM_db[i]); 
			
			
			//	[missingTileImages appendString:tileWordPicImageNM_db[i]];
			[logString appendFormat: @"%@:",tilePicPicImageNM_db[i]];
			//
			//		[missingTileImages [NSString stringWithFormat:@"%@>%@:", missingTileImages, tilePicPicImageNM_db[i]];
			
			//			NSLog(@"\n\n\n");
		}
		
		//		fileLocation = @"";
	}
	/*
	 if (lenS == lenF) {
	 NSLog(@"\n\n\nThere are missing tiles!!!\n\n");
	 }
	 
	 */
	
	NSLog(@"\n\n%@\n\n\n", logString);
	
	
	} // end of checkImageFileNames
	
	// end of check for image files ---------------------->>>>>>>>>>>>>>
	
	//  based on selected set to use, populate operating arrays for game do 36 assignments (adjust tileIDs!!!) 
	//  100911 file push do in own routine? -- call with setID.
	
//	NSLog(@"Now to load tiles in case new tile set is being used ... ===============>\n\n");

	[self loadWorkingTilez];
	
//	wordzSetNameL1 = setNM[gSetIDX];
// 	NSLog(@"We are working with set setID[gSetIDX] of  %d, %@", setID[gSetIDX], setNM[gSetIDX]); // 
	
//  wordzSetNameL1 = @"On The Go";
//	wordzSetNameL2 = @"在去";
//	wordzSetType = @"PS";
//	wordzSetLang1 = @"EN";
//	wordzSetLang2 = @"CN";
	
//	wordzSetLangDesc1 = @"English";
//	wordzSetLangDesc2 = @"Chinese (中文)";
	
	// re-randomize every time -- so ALWAYS do new randomizing arrays, below...
	
	
	
	// 100905 DBCHANGE BEGIN   
	/*
	
	tileLangID[0] =		@"EN";
	tileNM[0]     =		@"boat";
	wordTXT[0]    =		@"boat";
	pictureIND[0] =		'Y';
	matchingTileNM[0] =	@"chuan2";
	matchingTileIDX[0] = 5;
	tileWordPicImageNM[0] = @"boat_word100.jpg";
	tilePicPicImageNM[0]  = @"boat_chuan2_pic100.jpg";
	
		DELETED ALL other 34 assignment blocks. these document how arrays are set.
	
	tileLangID[35] =		@"CN";
	tileNM[35]     =		@"gong1gong4qi4che1";
	wordTXT[35]    =		@"公共汽车";
	pictureIND[35] =		'Y';
	matchingTileNM[35] =	@"bus";
	matchingTileIDX[35] = 34;
	tileWordPicImageNM[35] = @"gong1gong4qi4che1_word100.jpg";
	tilePicPicImageNM[35]  = @"bus_gonggongqiche_pic100.jpg";
	
	*/
	// 100905 DBCHANGE END   	
	
	// end of 36 tiles	
	
	//	tindex[36] then initialied so elements 0 to 35 contain ramdomized
	//  quick hardcode for testing / compile
	
	/*   the first hand-randomized array for FC (flash card) tile and filling up tile board. left in for no reason...
	
	tindex[0]   = 6;
	tindex[1]   = 9;
	tindex[2]   = 29;
	tindex[3]   = 3;
	tindex[4]   = 19;
	tindex[5]   = 22;
	tindex[6]   = 1;
	tindex[7]   = 15;
	tindex[8]   = 33;
	tindex[9]   = 0;
	
	tindex[10]   = 5;
	tindex[11]   = 8;
	tindex[12]   = 28;
	tindex[13]   = 2;
	tindex[14]   = 18;
	tindex[15]   = 21;
	tindex[16]   = 35;
	tindex[17]   = 14;
	tindex[18]   = 32;
	tindex[19]   = 34;
	
	tindex[20]   = 4;
	tindex[21]   = 7;
	tindex[22]   = 27;
	tindex[23]   = 11;
	tindex[24]   = 17;
	tindex[25]   = 20;
	tindex[26]   = 31;
	tindex[27]   = 13;
	tindex[28]   = 30;
	tindex[29]   = 26;
	
	tindex[30]   = 25;
	tindex[31]   = 24;
	tindex[32]   = 23;
	tindex[33]   = 16;
	tindex[34]   = 12;
	tindex[35]   = 10;
	*/
	
 
	//  Game Setup -- Randomize tiles and FCs 

	//  numbers from 0 to 35 -- then the tiles are assigned in the random
	// start of array randomization hal 100815
	amin = 0; 
	arrayPTR = 0; // this is where the next new random number goes
	
	// srand(time(NULL)); // make sure reand is reseeded 
	// switch to arc4random() 
	
//	NSLog(@"Now to randomize tiles... ===============>\n\n");

	
	while (amin == 0) {
		
		// generate number 	
		// test if "new"
		// if yes, add to array 
		// if array full, done
		
		anew = arc4random() % 36 ;	
		isNew = TRUE;
		
		for (int i=0; i < arrayPTR; i++) {
			if (anew == tindex[i]) {
				isNew = FALSE;
			}	
		}	
		if (isNew) {
			tindex[arrayPTR] = anew;
			if (easyFLAG == 1) {
				fcseqn[arrayPTR] = anew;
			}
//			NSLog(@"For tile order, Found %d number as %d.", arrayPTR, anew);
			arrayPTR++;
		}
		
		if (arrayPTR > 35) {
			amin = 1 ; // break out of while loop
		}
		
	}
	
	
	//   end of array randomization hal 100815 tile order
	amin = 0; 
	arrayPTR = 0; // this is where the next new random number goes
	
	while ((amin == 0) && (easyFLAG == 0)){   // not required for easyFLAG == 1 scenarios
		
		// generate number 	
		// test if "new"
		// if yes, add to array 
		// if array full, done
		
		anew = arc4random() % 36 ;	
		isNew = TRUE;
		
		for (int i=0; i < arrayPTR; i++) {
			if (anew == fcseqn[i]) {
				isNew = FALSE;
			}	
		}	
		if (isNew) {
			fcseqn[arrayPTR] = anew;
//			NSLog(@"for FCs, Found %d number as %d.", arrayPTR, anew);
			arrayPTR++;
		}
		
		if (arrayPTR > 35) {
			amin = 1 ; // break out of while loop
		}
		
	}
	
	
	//   end of array randomization hal 100815 -- FC order
	
	/* move this to one time area 
	
	tileBackPicImageNM = @"tileback_01.jpg";//   hard coded tile back pic. try animation later.
	
	imageBack = [UIImage imageNamed:tileBackPicImageNM];
	 */
	
} // end of initializeData

-(void) loadWorkingTilez {            // 100911 MOVE dbTilez to workingTilez -- one set !!                 
	// gSetIDX is index into SetNM, SetID 
	
	/*   settings have set as 1
	 
	gSetIDX = 1  but setname is 02 basic food and gSetID is 0 
	 
	*/ 

	//	wordzSetNameL1 = setNM[gSetIDX];
	// 	NSLog(@"We are working with set setID[gSetIDX] of  %d, %@", setID[gSetIDX], setNM[gSetIDX]); // 

	
	// gSetID  is SetID[gSetIDX]
	// all tilez are in _db[108] arrays.  for one set, need to move 36 items to base (tileNM etc) arrays as 0 to 35...
	
	gSetID = setID[gSetIDX];
	wordzSetNameL1 = setNM[gSetIDX];

    /*
	NSLog(@"\nin loadWorkingTilez and gSetID is %d and wordzSetNameL1 is %@ and gSetIDX is %d ", gSetID, wordzSetNameL1, gSetIDX);
	NSLog(@"\nName is from setNM[gSetODX].");
	*/
	
// ======= Start to move
	//   110112          if setID is randSetID, then do special setup...
	// do this in loadRWorkdingTilez routine??? 
	//                      genrate 18 random numbers from 1 to max tile number...
	//                      get matcing tile idx for those 18 number
	//                      now have array of 36 tiles..
	//
	//                      else set up based on gSetIDX 
	
	
	int startDBptr = (36 * (gSetIDX - 1)); // start is 0 for set 1, 36 for set 2, 72 for set 3
	int tempSetBasePtr = startDBptr;
	
	for (int hh = 0; hh < 36; hh++) {
		
	//	tileNM[hh]=@"";
		
		tileNM[hh] = [[NSMutableString alloc] initWithString:tileNM_db[startDBptr]];
		
//		[NSMutableString stringWithString: tileNM_db[startDBptr]];
		
//		NSLog(@"i did assign %@ to %@ for tile %d", tileNM[hh], tileNM_db[startDBptr], hh);  // 100918 may need to clear these too!

		tileLangID[hh]         = [[NSMutableString alloc] initWithString: tileLangID_db[startDBptr]];
		wordTXT[hh]            = [[NSMutableString alloc] initWithString: wordTXT_db[startDBptr]];
		matchingTileNM[hh]     = [[NSMutableString alloc] initWithString: matchingTileNM_db[startDBptr]];
		tileWordPicImageNM[hh] = [[NSMutableString alloc] initWithString: tileWordPicImageNM_db[startDBptr]];
		tilePicPicImageNM[hh]  = [[NSMutableString alloc] initWithString: tilePicPicImageNM_db[startDBptr]];
		
		tileHint[hh]		   = [[NSMutableString alloc] initWithString: tileHint_db[startDBptr]]; // 101216
																					
		
		pictureIND[hh]         = pictureIND_db[startDBptr];
		matchingTileIDX[hh]    = matchingTileIDX_db[startDBptr] - tempSetBasePtr;
		
		/*	
		 
		 these lines were resulting in bad access:
		 /////
		 tileLangID[hh]         = [NSMutableString stringWithString: tileLangID_db[startDBptr]];
		 wordTXT[hh]            = [NSMutableString stringWithString: wordTXT_db[startDBptr]];
		 matchingTileNM[hh]     = [NSMutableString stringWithString: matchingTileNM_db[startDBptr]];
		 tileWordPicImageNM[hh] = [NSMutableString stringWithString: tileWordPicImageNM_db[startDBptr]];
		 tilePicPicImageNM[hh]  = [NSMutableString stringWithString: tilePicPicImageNM_db[startDBptr]];
		 pictureIND[hh]         = pictureIND_db[startDBptr];
		 matchingTileIDX[hh]    = matchingTileIDX_db[startDBptr] - tempSetBasePtr;
		 /////
	
	tileLangID_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,2)];
	wordTXT_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,4)];
	matchingTileNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,6)];
	tileWordPicImageNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,8)];
	tilePicPicImageNM_db[jj] = [[NSString alloc] initWithUTF8String: (char*) sqlite3_column_text(compiledStatement,9)];
	
	 pictureIND_db[jj] = sqlite3_column_int(compiledStatement, 5);
	 matchingTileIDX_db[jj] = sqlite3_column_int(compiledStatement, 7);
	 
	 
	 */
		
		/*
		 NSLog(@"working arrays:  arrays with idx %d =======>\ncol1: %@ \tcol2: %@ \tcol3: %@ \tcol4 %d \ncol5 %@ \tcol6 %d \tcol7 %@ \tcol8 %@\n\n",
		 hh, tileLangID[h], tileNM[hh], wordTXT[hh], pictureIND[hh], 
		 matchingTileNM[hh], matchingTileIDX[hh], tileWordPicImageNM[hh], tilePicPicImageNM[hh]
		 );
		 
		 */
		startDBptr++;   // increment ptr into database array
		  
	}
	
	
}	
// ========End of move	
	


- (void)initBoardW2W {
    
    NSLog(@"entered illgal routine... ");
} // end of initBoardW2W


- (void)initBoardW2P {
	//	 NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
	
//	 NSLog(@"in W2P // Match mode is %@", matchMode);
//     NSLog(@"in W2P // pictureLang is %@", pictureLang);
    
// halprog	ver 3.00 fix
		 
	 
	int count = 0;   // initially 
	
	
	for (int y = 0; y < TILES_HEIGHT; y++)
	{
		for (int x = 0; x < TILES_WIDTH; x++)
		{
			if ([tileLangID[tindex[count]] isEqualToString: pictureLang]) {
				
				UIImage *image =[UIImage imageNamed:
								 tileWordPicImageNM[tindex[count]]];
/*				
				UIImage *image =[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",
																		 [[NSBundle mainBundle] bundlePath],
																		 tileWordPicImageNM[tindex[count]]]];         // also no autorlease on UIImage 
*/				
				
				// NSLog(@"I am here - W2P -- got Word image!");
				tiles[x][y]		= [[UIImageView alloc] initWithImage:image]; // NO autorelease 100918
				tileSaves[x][y] = tileWordPicImageNM[tindex[count]];
                /*
				NSLog(@"\n -->110321 -a- I am here - WP= -- for %d x %d got image %@!", x, y, tileWordPicImageNM[tindex[count]]);   // 100917			
				NSLog(@"\n Image path is: %@/%@.\n", [[NSBundle mainBundle] bundlePath], tileWordPicImageNM[tindex[count]]);		// 100920		 				
				*/
                
				CGRect newFrame   = tiles[x][y].frame;
				newFrame.origin   = CGPointMake((XBOARDORIGIN + (x * 102)), (y * 102) + YBOARDORIGIN);
				tiles[x][y].frame = newFrame;
				[self.view addSubview:tiles[x][y]];

//				[image release];											// release image above. 100920
				
				/*
				 NSLog(@"X = %d, y = %d, count: %d and tindex = %d.", x, y, count, tindex[count]);
				 NSLog(@"pics: %d, Word pic: %@, Pic pic: %@", count, 
				 tileWordPicImageNM[tindex[count]],
				 tilePicPicImageNM[tindex[count]]);
				 NSLog(@"x, y co-ord of image is %d, %d)", 
				 XBOARDORIGIN + (x * 102), 
				 (y * 102) + YBOARDORIGIN);
				 NSLog(@"End of element %d, %d",count, tindex[count] );
				 */
			}
			else {
				UIImage *image =[UIImage imageNamed:
								 tilePicPicImageNM[tindex[count]]];

				
/*				UIImage *image =[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",
																		 [[NSBundle mainBundle] bundlePath],
																		 tilePicPicImageNM[tindex[count]]]];         // also no autorlease on UIImage 
*/				
				// NSLog(@"I am here - W2P -- got Pict image!");
				tiles[x][y]		= [[UIImageView alloc] initWithImage:image] ; // no autorelease 100918 
				tileSaves[x][y] = tilePicPicImageNM[tindex[count]];
				/*
				NSLog(@"\n -->110321 -b- I am here - WP<> - for %d x %d got image %@!", x, y, tilePicPicImageNM[tindex[count]]);   // 100917	
				NSLog(@"\n Image path is: %@/%@.\n", [[NSBundle mainBundle] bundlePath], tilePicPicImageNM[tindex[count]]);		// 100920		 				
				*/
				CGRect newFrame   = tiles[x][y].frame;
				newFrame.origin   = CGPointMake((XBOARDORIGIN + (x * 102)), (y * 102) + YBOARDORIGIN);
				tiles[x][y].frame = newFrame;
				[self.view addSubview:tiles[x][y]];

//				[image release];											// release image above. 100920
				
				// debug
				
				// NSLog(@"I am here - W2P -- got image!");
				// NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
				
				/*	
				 NSLog(@"X = %d, y = %d, count: %d and tindex = %d.", x, y, count, tindex[count]);
				 NSLog(@"pics: %d, Word pic: %@, Pic pic: %@", count, 
				 tileWordPicImageNM[tindex[count]],
				 tilePicPicImageNM[tindex[count]]);
				 NSLog(@"x, y co-ord of image is %d, %d)", 
				 XBOARDORIGIN + (x * 102), 
				 (y * 102) + YBOARDORIGIN);
				 NSLog(@"End of element %d, %d",count, tindex[count] );
				 */
			}
			tilePointer[x][y] = tindex[count]; // note pointer is direct Array IDX			
			count++;
			tileState[x][y] = 1;
			
		}
		
	}	
	
} // end of initBoardW2P

- (void)initializeTileBoard
{
    
//	NSLog(@"Initialize tile board.... \n"); // halprog
//	NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);

	
	/*  
	 
	 match mode:  PP, WP or CC   // add CC 100912 hal 
	 FC: picture Lang:  EN, CN, 
	 
	 should also just do every time for new game with new set or not 
	 
	 */
	
	
	
// 	gameLanguage = @"EN"; // pull this from set data next
	
	wordzSetLabelNM.text = wordzSetNameL1;  // same for all DBs? check...  version 3.00 halprog 110716
	
/*	
	
	if ([gameLanguage isEqualToString: wordzSetLang1]) {
		wordzSetLabelNM.text = wordzSetNameL1;
	} else {
		if ([gameLanguage isEqualToString: wordzSetLang2]) {
			wordzSetLabelNM.text = wordzSetNameL2;
		} else {
			wordzSetLabelNM.text = @"Unknown";
		}
	}

*/		

	
	
//	matchMode = @"W2P";   // moved to preferences note W2W is now PP -- or WW!! 100912
//	FC pictureLang = @"CN";  // moved to user preferences
	

//	NSLog(@"\n\nWe have mm of %@ and pl of %@...  ================= \n", matchMode, pictureLang);
	
	// try this to improve sticky tiles problem:
	// nope, sticky tiles were just missing images.
	// but use to dealloc prior set objects.. 
	
	/*   CODE RAN, DIDN'T FIX PROBLEM. BUT DIDN'T CRASH.   PRIOR SUBVIEWS STILL THERE. 110320 
	NSLog(@" harry 110320 try dealloc old UIImageViews ...");
	NSLog(@" harry 110320 try dealloc old UIImageViews ...");
	NSLog(@" harry 110320 try dealloc old UIImageViews ...3");	

     try removing and releaseing old subviewss...
     
     this worked!!!! and released all the old subview memory too i bet!!!  yea!!! 110324 
	
*/	
	int countr = 0;   // initially 
	
	// 
	for (int y = 0; y < TILES_HEIGHT; y++)
	{
		for (int x = 0; x < TILES_WIDTH; x++)
		{
  
            [tiles[x][y]  removeFromSuperview ];
//          tiles[x][y] = nil;                            // not needed i guess. removed again 11/04/04s
            
//			tiles[x][y] = nil; //  also tried [tilez[x][y] release]; but crahsed.	
			countr++;
			
		}
	}
//    NSLog(@"YOu just released 36 subviews... or %d many.", countr);
    /*
     
	*/
	 
	//
	
	// NSLog(@"\n\t\t\tdid release %d times", countr);
    
    // version 3.00 fix halprog !! next check these -- !!!
    //  110716 
	/*
	if (([matchMode isEqualToString: @"PP"]) ||
		([matchMode isEqualToString: @"WW"])){
		//		NSLog(@"Will perform WW and PP initialization.");
		[self initBoardW2W];
	}
	else if (([pictureLang isEqualToString: k_L1]) ||               // 110715 ver 3.0 change to variable from constant
			 ([pictureLang isEqualToString: kL2])) {
		//		NSLog(@"Will perform W2P initialization.");
//		pictureLang = matchMode; // ignore this input parameter
		[self initBoardW2P];
	}
    */   
    
    // halprog version 3.00 110716
    [self initBoardW2P];
//    NSLog(@"Will perform W2P initialization.");
	 
	{
		//			NSLog (@"Need to handle other options.");
		
		
	}  // end of final else condition on examining game mode and match mode
	
	
} // end of initialize tile board

#pragma mark -
#pragma mark Game Functions 

- (IBAction)giveHint {
//	NSLog(@"\n\t\tIn giveHint!!!");
    
    // remove -- no hints in french language learning...
    
    // halprog
    
    
	// put code in to move hint from array to status message. have to change loading routines to load up hints... 101216HINT
	
	// use value of fcPointer for current flash card. what is tileid in 0-35 arrau?
	// get that hint for message.
	// display message
	// play hintSound
	// increment hint counter
	// update score logic...
    //
    
    //hints only in English so not moved to Localized.strongs. no i18n. 
    //
	statusLabel.text = [ NSString stringWithFormat: @"Hint: >>%@<<",  //  // was tileHint[fcPtsArrayIDX  
						tileHint[fcseqn[fcPointer]]
						];
	hintCounter++;
	//		missedLabel.text = [ NSString stringWithFormat: @"%d", missed ];
	[hintSound play];
	
	// NSLog(@"We have hint for fcPtsArrayIDX %d, fcseqn(arrayidx) %d, fcseqn(fcPTR) %d, \n>%@<", fcPtsArrayIDX, 
	//	  fcseqn[fcPtsArrayIDX], fcseqn[fcPointer], tileHint[fcseqn[fcPointer]], tileHint[fcseqn[fcPtsArrayIDX]] );
	
	/*
	NSLog(@"\n fcPtsArrayIDX is %d, tileHint is >>%@<<.", fcPtsArrayIDX, tileHint[fcPtsArrayIDX]);
	NSLog(@"\n fcseqn[fcPtsArrayIDX]is %d, tileHint is >>%@<<.", fcseqn[fcPtsArrayIDX], tileHint[fcseqn[fcPtsArrayIDX]]);
	NSLog(@"\n\n fcseqn[fcPointer] is %d, tileHint is >>%@<<.", fcseqn[fcPointer], tileHint[fcseqn[fcPointer]]);
	NSLog(@"\n\n fcPointer is %d, tileHint is >>%@<<.", fcPointer, tileHint[fcPointer]);
	NSLog(@"\n tindex[fcPointer] is %d, tileHint is >>%@<<.", tindex[fcPointer], tileHint[tindex[fcPointer]]);
	*/
	
	
}

- (IBAction)createNewGame {
    
/*
 
 Version 3.0
 
 at start of each game, we should check the desired UI language, and 
 if it is set to last game UI language, continue on. if different, 
 we should reload all the working arrays from the appropriate database... and update the last game UI language info..
 
 halprog
 
 
 
 
 */
    
    
	lastRank = 101;
	missed = 0;
	hintCounter = 0; // 101216
	time = 0;
	fcPointer = 0;
//	NSLog(@"\n\t\tIn createNewGame!!!");
	
//	NSLog(@"\n\tparams of mm = %@,\t pl of %@ and gSetIDX of %d. \n", matchMode, pictureLang, gSetIDX); // hal 100912 
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	self.highScoreFilename = @"";
	self.highScoreFilename = [self.highScoreFilename stringByAppendingString:documentsDirectory];
	self.highScoreFilename = [self.highScoreFilename stringByAppendingString:kHighScoresFileName];
	self.highScoreTitle = @"Wordz Lianxi Scores";  // file name. no need to localize.
	
//	self.lastInitials = @"AAA";                             101224 dont do this.
	
//	NSLog(@"In create new game. Set up File name. or not? filename is %@", self.highScoreFilename);
	
	
	missedLabel.text = [ NSString stringWithFormat: @"%d", missed ];
	timeLabel.text = [ NSString stringWithFormat: @"%d", time ];
	needsNewGame = FALSE;
	// debug -- need to reset all tileStates, flipped up images   hal 100814 
	
	// set picture in first flash card:
	/* if ((match mode is PP) OR (tile lang and pictureLang match)) 
			set image to PicPic
	   else
			set image to WordPic
	   endIf
	 
	 this is tricky. see state diagram.  harry DEBUG 100814
	*/
	
	/*
	 need to walk through flash cards for fcPointer is 0 to 35,,,
	 
	 not using tindex(fcPointer( where fcPointer is 0 to 35, or that
	 is same order as array is filled,
	 
	 */
	/*
	set up maching pictures -- always say order for set; but they are moved
	  around in the board each time
	 
	 could also randomize the test squence... ugh ... probably should....
	 
	*/
	// was in viewDidLoad:
	
	
	// if firstGame is TURE, skip this release of arrays 
	
	/*
	if (firstGame) {
		NSLog(@"first game initialization; skip release of game arrays..."); // memory management 100918 
		firstGame = FALSE ; // just like 24c... 
		
		statusLabel.text = [@"User name is set to >" stringByAppendingString:lastInitials];   /// final fix
		statusLabel.text = [statusLabel.text stringByAppendingString:@"<. Update with Set User button any time."];   /// final fix		
		
		
		}  else {
		
		
		}
	
	 */
	
	  // end of non-firstGame initialization
	
	// end of firstGame else case
	// use this to clear status message at start of each game! 
	
	statusLabel.text = [usernamePt1String stringByAppendingString:lastInitials];       /// final fix
	statusLabel.text = [statusLabel.text stringByAppendingString:usernamePt2String];   /// final fix		

	[self initializeData];
	[self initializeTileBoard];
	
	isPlaying = YES;
    // begin pause state re-sync fix 110921
    if (pauseState == 1) {    // get resume / pause resync'd    110921
        pauseState = 0;
        //		[pauseButton setTitle: pauseString forState:(UIControlStateNormal)];
        [pauseButton setImage: pauseImage  forState:(UIControlStateNormal)];  // 110913        
		if (timer == nil) {
			timer = [NSTimer scheduledTimerWithTimeInterval:1.0 
													 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];        
        }
	} // also re-sycn play / learn? not needed.. 
    // end pause state re-sync fix 110921
	// from view did load
	
	
	/*
	 
	 FC pic ordering is as follows.  has w2w and w2p modes.
	 
	 if PP, all board tiles are picutres , so all FC tiles should be wordZ!!!
	 if WW, all board tiles are words, so all FC Tiles should be pics.
	 
	 if WP, then based on languages --
	 
	
	*/
	
	
	if (easyFLAG == 1) {				//										halprog change here? for WW ?? 100912
		
		
//		NSLog(@"\neasyFLAG is SET!!\n\n");	
		
	
	if (([matchMode isEqualToString: @"PP"]) ||
		
	    (([matchMode isEqualToString: @"WP"]) && 
		 ([tileLangID[tindex[fcPointer]] isEqualToString: pictureLang]))) {
		
		
		// use PicPic
			
//			NSLog(@"mm is PP or WP with lang match");
			
		[fcImageView setImage:[UIImage imageNamed:tilePicPicImageNM[tindex[fcPointer]]]];
//		NSLog(@"Set image to wordpic %@.", tilePicPicImageNM[tindex[fcPointer]]);
		
		
	} else {

//		NSLog(@"mm is WW or WP with lang mis-match");
		
		[fcImageView setImage:[UIImage imageNamed:tileWordPicImageNM[tindex[fcPointer]]]];
//		NSLog(@"Set image to wordword %@.", tileWordPicImageNM[tindex[fcPointer]]);

	
	
	}
  
//	NSLog(@"Init first FCimage use %d! points to %d", fcPointer, tindex[fcPointer]);
//	NSLog(@"______(using easy) _________");
//	NSLog(@"____________________________");
  
        
	} // easyFlag sequencing of flashCards / fcPointer
	
	
	
	
	
	else {
		if (([matchMode isEqualToString: @"PP"]) || 
			([tileLangID[fcseqn[fcPointer]] isEqualToString: pictureLang])) {
			// use PicPic
			[fcImageView setImage:[UIImage imageNamed:tilePicPicImageNM[fcseqn[fcPointer]]]];
//			NSLog(@"Set image to picpic %@.", tilePicPicImageNM[fcseqn[fcPointer]]);
		} else {
			[fcImageView setImage:[UIImage imageNamed:tileWordPicImageNM[fcseqn[fcPointer]]]];
//			NSLog(@"Set image to wordpic %@.", tileWordPicImageNM[fcseqn[fcPointer]]);
		}
		
//		NSLog(@"Init first FCimage use %d! points to %d", fcPointer, tindex[fcPointer]);
//		NSLog(@"_____(not using easy)_______");
//		NSLog(@"____________________________");
	}
	
	if (timer == nil) {
		pauseState = 0; // not paused
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
	}
}	

/* remove this

- (void)startPlaying {
	[self createNewGame];
}
*/ 

-(IBAction) setReviewMode {                      //101228
	
	
	if (easyFLAG == 0) {
		easyFLAG = 1;	
        //		NSLog(@"\nSet easyFLAG = 1; now easy."); 
		
        //		[setReviewModeButton setTitle: noEasyString forState:(UIControlStateNormal)];
        [setReviewModeButton setImage: playImage  forState:(UIControlStateNormal)];        // 110913
        
        
        
		modeLabel.text =	easyString;															// 110208 set mode label
		[hintSound play];
        
		[self createNewGame];
        
        
	}
	else {
		easyFLAG = 0;
        //		NSLog(@"\nSet easyFLAG = 0; now NOT easy."); 
        //		[setReviewModeButton setTitle: easyString forState:(UIControlStateNormal)];
        [setReviewModeButton setImage: reviewImage  forState:(UIControlStateNormal)];        // 110913
		modeLabel.text =	noEasyString;														// 110208 set mode label		
		[hintSound play];
        
		[self createNewGame];

	
	}
	
}

- (IBAction)pauseGame  {
//	[theTimer invalidate];
//	theTimer = nil;

	if (pauseState == 0) {
		[timer invalidate];
		timer = nil;
		pauseState = 1;
		
        //		[pauseButton setTitle: resumeString forState:(UIControlStateNormal)];
        [pauseButton setImage: resumeImage forState:(UIControlStateNormal) ];        // 110913
	}
	else {
		pauseState = 0;
        //		[pauseButton setTitle: pauseString forState:(UIControlStateNormal)];
        [pauseButton setImage: pauseImage  forState:(UIControlStateNormal)];  // 110913        
		if (timer == nil) {
			timer = [NSTimer scheduledTimerWithTimeInterval:1.0 
													 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
		}
		
		
	}
	
	//	[theTimer invalidate];
	//	theTimer = nil;

}


/* CADisplayLink type timer stuff 

-(void)initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self 
											   selector:@selector(gameLogic)];
		theTimer.frameInterval = 2;
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop] 
					   forMode: NSDefaultRunLoopMode];
	}
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	int touchLocX, touchLocY;  // working vars to figure out which tile is touched
	int IndX, IndY; // pointer into image array 
	
	IndX = 1;  IndY = 1;
	//	NSLog(@"I am here - touches begin!");
	
	// NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
	
	// NSLog(@"X = %d, y = %d, count: %d and tindex = %d.", x, y, count, tindex[count]);
	// NSLog(@"er: %d, Word pic: %@, Pic pic: %@", count, 
	//			tileWordPicImageNM[count],
	//			tilePicPicImageNM[count]);
	
	
	
	if (isPlaying) {
		UITouch *touch = [[event allTouches] anyObject];
		// print where in main view this touch is
		lastTouchLocX = [touch locationInView:touch.view].x;
		lastTouchLocY = [touch locationInView:touch.view].y;
		// figure out which tile touched
		
		//		NSLog(@"X = %d, y = %d.", lastTouchLocX, lastTouchLocY);	
		
        /* original code 110816
         
         if ((    lastTouchLocX  > XBOARDORIGIN ) && (  lastTouchLocX < XBOARDORIGIN + ((TILES_WIDTH +2) * TILESIZE)) &&
         (    lastTouchLocY  > YBOARDORIGIN ) && (  lastTouchLocY < YBOARDORIGIN + ((TILES_HEIGHT +2) * TILESIZE))
         )  {
         
         
         END OF ORIGINAL CODE BLOCK 110816 */
		
		if (( lastTouchLocX  > XBOARDORIGIN ) && (  lastTouchLocX < XBOARDORIGIN + (TILES_WIDTH  * (TILESIZE + 2)))   &&
			( lastTouchLocY  > YBOARDORIGIN ) && (  lastTouchLocY < YBOARDORIGIN + (TILES_HEIGHT * (TILESIZE + 2)))
			)
        {
			// normalize x, y rec'd to relative to 0.0 top left of board  
			touchLocX = lastTouchLocX - XBOARDORIGIN;
			touchLocY = lastTouchLocY - YBOARDORIGIN;
			
			for (int j = 0; j < TILES_WIDTH; j++) {
				if (touchLocX > TILESIZE + 1)   {
					//				NSLog(@"J = %d, touchLocX = %d", j, touchLocX);
					touchLocX = touchLocX - TILESIZE - 1;
					IndX++;
				}
			}
			
			for (int k = 0; k < TILES_HEIGHT ; k++) {
				if (touchLocY > TILESIZE + 1)  {
					//				NSLog(@"k = %d, touchLocY = %d", j, touchLocY);
					touchLocY = touchLocY - TILESIZE - 1;
					IndY++;
				}
			}
			
			//  NSLog(@"in touchesBegin for imageArray X = %d, y = %d.", IndX, IndY);	  
			//	here they must have clicked a tile
			
			IndX--;
			IndY--;
			// update hal 100815 if pauseState = 1 then ignore click. nessage.
			
			if (pauseState == 1) {
				statusLabel.text = gamePausedString;
                [incorrectSound play];                   //110921
			} else {
				
			[self tileClicked:IndX  withY:IndY];	
			}
			
		}
	} else{
//		[self startPlaying]; // debug - check this? don't do anything
	}
}




-(void)tileClicked:(int)indexX withY:(int)indexY {
	// 110208 
	
//	NSString *clickMessage; 
	

	
	//  NSLog(@"%s %d %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);

//	NSLog(@"\n\nhave x as %d and y as %d.=============  in tileClicked  ===============================\t\n", indexX, indexY);
//    NSLog(@"The name of the picture in this tile should be: %@", tileSaves[indexX][indexY]);
	/* 
	This section moves game forward, click by click, only for clicks on the game board.
	fcPointer, or flashcardPointer, will point to the first 
		of 35 cards in the deck at the start of the game. 
	 
	 
	Each game board click will be a "move", and each move will result in:
	 0 - the 'current' tile is the tile at  fcseqn or tindex [fcPointer] for pointers 0 to 35
	 
	 (up in new game init:
	 if new game, set fcPointer to zero, pt zero'th FC image in fcImageView UIImageView
	 
	 )
	 
	 
	 1 - ignored if tile is 'dead' (complete, or flipped)
	 2 - check tile for match, if tile is available (unflipied)
		a - if match, play correct, check for end of DECK (fcPointer == 35)
		   1 - if fcPointer =36 
				process end of game!!
		   2 - otherwise
				increment fxPointwe, upsRW DXIMfwCiwq UIImage
	    b - if nomatch, play error tone, increment error counter
	 3 - will add a quit button i guess.
	 4 - restart should reset timer, tiles, missed and other counters, fcPointer to 0
	 
	 
	 
	*/
	
	//  if (1.0 == bricks[x][y].alpha)
	if (tileState[indexX][indexY] == 1) // if tile not flipped  aka face up aka State 1
	{
		selPointer = tilePointer[indexX][indexY]; 
		
//		int jj = selPointer;
		
//		NSLog(@"\nselPointer is %d", jj);
//		NSLog(@"\tlang is %@", tileLangID[jj]);
//		NSLog(@"\ttileNM is %@", tileNM[jj]);
		
//		NSLog(@"\twordTXT is %@", wordTXT[jj]);
//		NSLog(@"\tPicIND is %d", pictureIND[jj]);
//		NSLog(@"\nMatchingTileNM is %@", matchingTileNM[jj]);
//		NSLog(@"\tmatchingTileIDX is %d", matchingTileIDX[jj]);
//		NSLog(@"\tword Pic image is %@", tileWordPicImageNM[jj]);
//		NSLog(@"\t pic Pic image is %@", tilePicPicImageNM[jj]);
//		NSLog(@"\n ---- HAL 110321 ---");

		/*
		NSLog(@"SelPointer tells about this tile: arrays with idx %d =======>\ncol1: %@ \tcol2: %@ \tcol3: %@ \tcol4 %d \ncol5 %@ \tcol6 %d \tcol7 %@ \tcol8 %@\n\n",
			  jj, tileLangID[jj], tileNM[jj], wordTXT[jj], pictureIND[jj], 
			  matchingTileNM[jj], matchingTileIDX[jj], tileWordPicImageNM[jj], tilePicPicImageNM[jj]
			  );
		
		*/
		
		/*  
		selPointer is tindex[count] for tileboard tiles, pointing into 
						master arrays directly
		fcPtsArrayIDX is same thing for flash card -- 
							either tindex(fcPointer) or
							fcseqn(fcPointer), depending if easy or hard.
		 so match logic must look for:
		 
		 if ((fcPtsArrayIDX == selPointer) OR
			 (matchingTileIDX[fcPtsArrayIDX] == selPointer) OR
			 (fcPtsArrayIDX == matchingTileIDX[selPointer]) OR
		     (matchingTileIDX[fcPtsArrayIDX] == matchingTileIDX[selPointer])
		 
		 THEN WE HAVE A MATCH
		 
		*/
		if (easyFLAG == 1) {
			fcPtsArrayIDX = tindex[fcPointer]; 
		} else {
			fcPtsArrayIDX = fcseqn[fcPointer]; 
		}
		
		/* 101216BB
		NSLog(@"____________________________");
			NSLog(@"\n\n____ we have a live tile ___");
			NSLog(@"easyFLAG is %d", easyFLAG);
			NSLog(@"fcPtsArrayIDX is %d", fcPtsArrayIDX);
		*/ 
		// remember to increment fcPointer after match
		
//		NSLog(@"\n\n____________________________");	
//		NSLog(@"We have live tile %d, %d", indexX, indexY);
//		NSLog(@"fcPointer is %d", fcPointer);
//		NSLog(@"fcPointer points to array position %d, fcPtsArrayIDX is at array %d", 
//			  fcPointer, fcPtsArrayIDX);
		//			NSLog(@"_\n\n___last line before crash. ____\n\n____________________");	
		
//		NSLog(@"\ncurrent fc %d has lang of %@ tileNM of %@", 
//			  fcPtsArrayIDX, tileLangID[fcPtsArrayIDX], tileNM[fcPtsArrayIDX]);
//		NSLog(@"--------------------------------------");
//		NSLog(@"current selptr %d has lang of %@ tileNM of %@", 
//			  selPointer, tileLangID[selPointer], tileNM[selPointer]);
//		NSLog(@"--------------------------------------");		
//		NSLog(@"tile at position fcPtsArrayINDX has matchIDX --matchingTileIDX[fcPtsArrayIDX ]--of %d", 
//				matchingTileIDX[fcPtsArrayIDX ]);
//		NSLog(@"tile in array position fcPtsArrayIDX -- fcPtsArrayIDX, matchingTileIDX[fcPtsArrayIDX]--  %d also matches card at (here) array %d", 
//			  fcPtsArrayIDX, matchingTileIDX[fcPtsArrayIDX]);
		
		 // note: if fcPtsArrayIDX == selPointer, they are same card
		//       if fcPtsArrayIDX == matchingTileIDX[fcPtsArrayIDX ], matching card
		//
//		NSLog(@"match if either fcPtsArrayIDX == selPointer, that is -- fcPtsArrayIDX, selPointer --  %d == %d", 
//			  fcPtsArrayIDX, selPointer);
//		NSLog(@"match if either fcPtsArrayIDX == matchingTileIDX[fcPtsArrayIDX] -- fcPtsArrayIDX, matchingTileIDX[fcPtsArrayIDX]-- %d == %d", 
//			  fcPtsArrayIDX, matchingTileIDX[fcPtsArrayIDX]);
//
  //
// 		  NSLog(@"preventEM value is %d", preventEM);
//        NSLog(@"--------------------------------------");	     
        //this is the "with exact matches logic" as of 11-04-04 --- start of changes to be done.
        // for exact matches -- either match as now, if preventEM is 0, else message area says "exact matches not allowed! change settings to allow." and do nomatch logic.
        //  11-04-04  everything else is coded and seems good -- clean compile, not debugged / verified.  global var is preventEM as int.
        //  this is pretty tricky and i have to re-figure it out each time:
        //  remember: two sets of tils, each set has both EN and CN version of a word.
        //  so normally can match either to either.
        //  with preventEM  only can match EN tile to EN tile, CN tile to CN tile -- that is, tile to exact match of self / tile ID -- 
        // can't match chuan2 with boat or you'd have to allow two boat pictures to match! see!!!
        // also must pick up vallues from setttingsviewcontroller in did finish routine, even if written out in settingviewcontroller to user store
        //
        //  note well:  preventing matches makes error messages look a little strange (fix?) and if done mid-game can make a game unwinable..
        //
        
		if  ( 
             ((preventEM == 0) && 
            
               ((fcPtsArrayIDX == matchingTileIDX[selPointer]) || (matchingTileIDX[fcPtsArrayIDX] == selPointer))
              
            
              
              ) 
             
             
             ||  
                    ((fcPtsArrayIDX == selPointer) || (matchingTileIDX[fcPtsArrayIDX] == matchingTileIDX[selPointer])) 
            
             
             )
             
        
             
            /*    -- old logic, pre preventEM  
             
            ((fcPtsArrayIDX == selPointer) ||
			(fcPtsArrayIDX == matchingTileIDX[selPointer]) ||
			(matchingTileIDX[fcPtsArrayIDX] == selPointer) ||
			(matchingTileIDX[fcPtsArrayIDX] == matchingTileIDX[selPointer]))
            */
            
            
            
            
		{		// match!! and not flipped  			
		/*
         
         note: need to change big bracket to chec for match under preventEM or no preventEM; so ELSE will handle NOMATCH correctly...
         but maybe this way no "exact match" specific error message?  would be nice... 
		 
				 note: 11-04-04 -- change to prevent exact match either way, optionally. solves problem.
		 
		 CASES:		1) SAME TILES, 
		 
						a) CN  tileNM or tile TXT = matching tile tileTXT.
						b) EN  tileTXT = matching tile tileNM or tileTXT
		 
					2) MATCHING TILES.
		 
						a) CN  tileNM or tile TXT = matching tile tileTXT.
						b) EN  tileTXT = matching tile tileNM or tileTXT

		 
		*/ 
				
//			 	NSLog(@"______match______________________");
			
			if  (fcPtsArrayIDX == selPointer) {
//				NSLog(@"Both same tile.");
				if ([tileLangID[selPointer] isEqualToString: kL2] ) {
//				NSLog(@"Both same tile, CN.");	
		
					statusLabel.text = [NSString stringWithFormat: yesAisBString,
//										tileNM[fcPtsArrayIDX ], 
										wordTXT[fcPtsArrayIDX], 
										wordTXT[selPointer]
                                        ]; //, 
//										tileNM[matchingTileIDX[selPointer]]];
					
/*					NSLog (@"Yes! case 1  %@ or %@ is %@.",
						   tileNM[fcPtsArrayIDX ], 
						   wordTXT[fcPtsArrayIDX], 
//							wordTXT[selPointer], 
						   tileNM[matchingTileIDX[selPointer]]);
*/				
					
					
					
					
				} else {
//				NSLog(@"Both same tile, EN.");		
					
					statusLabel.text = [NSString stringWithFormat: yesAisBString,
//										tileNM[fcPtsArrayIDX ], 
										wordTXT[fcPtsArrayIDX], 
										wordTXT[matchingTileIDX[selPointer]], 
										tileNM[matchingTileIDX[selPointer]]];
/*					NSLog(@"Yes! case 2 %@ is %@ or %@.",
//							tileNM[fcPtsArrayIDX ], 
						  wordTXT[fcPtsArrayIDX], 
						  wordTXT[matchingTileIDX[selPointer]], 
						  tileNM[matchingTileIDX[selPointer]]);
*/					
					
				}
				

			} else {
//				NSLog(@"Matching (diff) tiles.");
				if ([tileLangID[selPointer] isEqualToString: kL2] ) {
//					NSLog(@"Board tile / selPointer is CN.");	
					statusLabel.text = [NSString stringWithFormat: yesAisBString,
						//	tileNM[fcPtsArrayIDX ], 
							wordTXT[fcPtsArrayIDX], 
                            wordTXT[selPointer]];   //, 
//							tileNM[selPointer]];
/*					NSLog(@"Yes!  Case 3 %@ is %@ or %@.",
						  //	tileNM[fcPtsArrayIDX ], 
						  wordTXT[fcPtsArrayIDX], 
						  wordTXT[selPointer], 
						  tileNM[selPointer]);
*/					
					
				} else {
//					NSLog(@"Board tile / selPointer is  EN.");	
					statusLabel.text = [NSString stringWithFormat: yesAisBString,
//										tileNM[fcPtsArrayIDX ], 
										wordTXT[fcPtsArrayIDX], 
										wordTXT[selPointer]];
					
										//    tileNM[selPointer]];
/*					NSLog(@"Yes! Case 4 %@ or %@ is %@.",
						  tileNM[fcPtsArrayIDX ], 
						  wordTXT[fcPtsArrayIDX], 
						  wordTXT[selPointer]);
*/					
				}
			}

			
//   end of match logic allowing exact matches 11-04-04  
			
				 fcPointer++;
			
			//   NSLog(@" WE have a match.  tile board tile pic name is %@.",  tileSaves[indexX][indexY] ); 
			// note: above line shows correct image name, but image that is displayed is from prior game (except for first game).
			// we will rel0ad the image, then set the alhpha..... WHY???
			// ahhh ha!  the image name is CORRECT, but the image is something else!! so the image name is now associated with the wrong thing...
			//  from prior game... something not re-init..ed??? no clue...
			
			
			 
				 tileState[indexX][indexY] = 0;  // flip state to zero from 1 -- IF MATCH
				 [correctSound play];
			
//			     110309  flip if alpha = 0; fad if alpha = 1.
			if (useAlpha == 0) {
				//flip
//					[tiles[indexX][indexY] setImage:[UIImage imageNamed:tileBackPicImageNM]];
// begin flip v3.05
                [UIView transitionWithView:tiles[indexX][indexY] duration:flipDuration options:UIViewAnimationOptionTransitionFlipFromLeft 
                                animations:^{  
                                    [tiles[indexX][indexY] setImage:[UIImage imageNamed:tileBackPicImageNM]];
                                }
                                completion:NULL];                         
// end flip v3.05               
                
                
			} else {
//					[tiles[indexX][indexY] setImage:[UIImage imageNamed:tileSaves[indexX][indexY]]];  // halprog just commented out -- looked wrong???? 
					[tiles[indexX][indexY] setAlpha:0.7];
		
				
//				tiles[indexX][indexY].alpha = .7; // ] setImage:[UIImage imageNamed:tileBackPicImageNM]];    //110320  non-working alpha problem
//				[tiles[indexX][indexY] setAlpha:0.7];
//				[myImageView setAlpha:100.0];				
				
			}
			
//				 110307    instead of flip, fade the tile down to .30
			
				
				
				/*
				statusLabel.text = // @"Match
 					[ NSString stringWithFormat: @"Yes! %@ or %@ is %@ or %@",
					 tileNM[fcPtsArrayIDX ], wordTXT[fcPtsArrayIDX ], wordTXT[selPointer], tileNM[selPointer]];
				
				*/
				
				
				//100909 add tileNM 2nd
			 // update fcImage !!!  progress 
			 //--------------------------
			 
			 
			 if ((easyFLAG == 1) && (fcPointer < 36)) { // update fc tile image easy sequence     // begin changes 100912 for PP/WW/WP hal prog
				 if (([matchMode isEqualToString: @"PP"]) || 
					 (([matchMode isEqualToString: @"WP"]) &&
					  ([tileLangID[tindex[fcPointer]] isEqualToString: pictureLang])))	{
					 [fcImageView setImage:[UIImage imageNamed:tilePicPicImageNM[tindex[fcPointer]]]];
																							
//					 NSLog(@"\nis pp or wp with lang match.\nSet tindex image to picpic %@.", tilePicPicImageNM[tindex[fcPointer]]);
					 //		[tiles[indexX][indexY] setImage:[UIImage imageNamed:tileBackPicImageNM]];
					 
				 } else {
					 [fcImageView setImage:[UIImage imageNamed:tileWordPicImageNM[tindex[fcPointer]]]];
//					 NSLog(@"Set tindex image to wordpic %@.", tileWordPicImageNM[tindex[fcPointer]]);
				 }
			 }
				 // end of easy mode for next FC ; else use more complex next fc method
				 // remove else if to ease debugging
				 
			 if ((easyFLAG == 0) && (fcPointer < 36)) { // update fc tile image non-easy sequence 
				 if (([matchMode isEqualToString: @"PP"]) || 
					 ([tileLangID[fcseqn[fcPointer]] isEqualToString: pictureLang])) {
					 [fcImageView setImage:[UIImage imageNamed:tilePicPicImageNM[fcseqn[fcPointer]]]];
//					 NSLog(@"Set seqn image to picpic %@.", tilePicPicImageNM[fcseqn[fcPointer]]);
					 //		[tiles[indexX][indexY] setImage:[UIImage imageNamed:tileBackPicImageNM]];
					 
				 } else {
					 [fcImageView setImage:[UIImage imageNamed:tileWordPicImageNM[fcseqn[fcPointer]]]];
//					 NSLog(@"Set seqn image to wordpic %@.", tileWordPicImageNM[fcseqn[fcPointer]]);
				 }
			 }
			 
			 // fcPointer++;

			 if (fcPointer < 36) {
//			 NSLog(@"Init next FCimage use %d! points to %d", fcPointer, tindex[fcPointer]);
			 } else {
//				 NSLog(@"Matched last tile!");	 // then crash with easyFLAG = 0 100922
				 
			 }

//			 NSLog(@"____________________________");
//			 NSLog(@"____________________________");
			 
			 //--------------------------
			 
		 } else  {
			// not match and not flipped
//			NSLog(@"______noMatch______________________");
		//		NSLog(@"Do flip from 1 to zero for x %d y %d", indexX, indexY);
		//		NSLog(@"set tilestate x,y to: %d",tileState[indexX][indexY] );
		//		NSLog(@"tile top pic is %@",tileSaves[indexX][indexY] );
		//		NSLog(@"Do flip from zero to 1 for x %d y %d", indexX, indexY);
		
		/*
		tileState[indexX][indexY] = 1; // flip state back to 1 from zeron
		selPointer = tilePointer[indexX][indexY];
		fcPtsArrayIDX = tindex[fcPointer]; 
		
		 */ 
             
//             condEMmsg = [NSString stringwithFormat @"",  ;     
             
             
             
             
		// loged missed   101216 need to update these messages a little.
             
             if (preventEM == 0) {      
             
		statusLabel.text = [ NSString stringWithFormat: sorryAnotBneedCString, 
//							tileNM[fcPtsArrayIDX ],									//100905 added
							wordTXT[fcPtsArrayIDX ], 
							wordTXT[selPointer], 
//							tileNM[selPointer],  //100909 and one more.. 
							matchingTileNM[fcPtsArrayIDX]							//100905 added
							];
             } else {
                 // preventEM is in effect! 
        statusLabel.text = [ NSString stringWithFormat: sorryNOEMString, 
//							tileNM[fcPtsArrayIDX ],									//100905 added
                            wordTXT[fcPtsArrayIDX ], 
                            wordTXT[selPointer], 
//							tileNM[selPointer],  //100909 and one more.. 
                            matchingTileNM[fcPtsArrayIDX],							//100905 added
                            noExactMatchAllowedMsg                                  //110406 added special explaination if noEM in effect. 
                            ];

             }
             
             
        //halprog -- append exactmatch feature enabled msg if needed.      
		missed++;
		missedLabel.text = [ NSString stringWithFormat: @"%d", missed ];
		[incorrectSound play];
//		NSLog(@"We have MISS with tile %d, %d", indexX, indexY);
		// change image to front
		//				tiles[indexX][indexY].image = tileSaves[indexX][indexY].image;
		//				[tiles[indexX][indexY] setImage:imageBack];		
		/*
		[tiles[indexX][indexY] setImage:[UIImage imageNamed: tileSaves[indexX][indexY]]];
		[correctSound play];
		*/ 
		//		NSLog(@"Do 2 flip from zero to 1 for x %d y %d", indexX, indexY);
		//		NSLog(@"set tilestate x,y to: %d",tileState[indexX][indexY] );
		//		NSLog(@"tile top pic is %@",tileSaves[indexX][indexY] );
		 }
	}
	else {
		// end of if not match and not flipped 
		// statements here for clicked on dead tiles 
		//this works and dead tiles are ignored.
		/*
		NSLog(@"____________________________");	NSLog(@"____________________________");
		
		NSLog(@"We have dead tile %d, %d", indexX, indexY);
		NSLog(@"fcPointer is %d, selPointer is %d", fcPointer, selPointer);
		NSLog(@"fcPointer points to array position %d, fcPtsArrayIDX is at array %d", 
			  fcPointer, fcPtsArrayIDX);
		*/
		
		
	} // end of not flipped	

	// now see if fcPointer has been incremented to 35 -- you win!!!
	if (fcPointer == 36) {
		// you have won!!

		score = time+(10*missed) + (4*hintCounter);

		[timer invalidate];
		// [timer dealloc]; // just wrong!!
		timer = nil;
		
		isPlaying = NO;

		// NSString *msg;   // 110725b
		
		//   =================================here we bail out if they are in review mode. easyFLAG == 1 =============
		//   score not reported, doesn't count.
		// 
		
		if (!easyFLAG == 0) {                    // test if currently in review mode 101228
			
			statusLabel.text = endReviewGameString; 
			
		
		} else {                                 // else cluase of test if currently in review mode 101228
			// not review flag so this stuff counts...		}

		
        /*    
		if ((missed == 0) && (hintCounter == 0)) {
			msg = [ NSString stringWithFormat: @"You won in %d seconds!!!\nYou missed %d problems. No Hints! PERFECT!\nSet Name : %@\nScore : %d + 10×%d = %d",
				   time, missed, wordzSetNameL1, time, missed, score ];
		}
		else {
			msg = [ NSString stringWithFormat: @"You won in %d seconds!!!\nYou missed %d problems with %d hints.\nSet Name : %@\nScore : %d + (10×%d) + (4*%d) = %d\n", 
				   time, missed, hintCounter,  wordzSetNameL1, time, missed, hintCounter, score ];
		}
        */    
		
		statusLabel.text = [ NSString stringWithFormat: endOfGameMessageString, time, missed, wordzSetNameL1, time, missed, score ];

            // 	time, missed, hintCounter, wordzSetNameL1, time, missed, hintCounter, score ];
            
            
            
/*		
		NSLog(@"________you win!!! ____________________");	
		NSLog(@"___isPlaying = NO; enable start new game? ");
		NSLog(@"________you win!!! ____________________");	
*/
//            NSLog(@"________you win!!! _____AA_______________");	// halprog 110725
            
		// begin part two // ======================================================================================================
		NSString *scoreString = [[NSString alloc] initWithContentsOfFile:self.highScoreFilename];
		int rank = 11;
		
		
		if ([scoreString length] == 0) {
//			NSLog(@"Initial scoreString is null.");
			
//            NSLog(@"No high scores file... ");   // 110725
            
//			msg = [msg stringByAppendingString:@"\nYou got the high score!"]; // not used -- not localized.   crashes -- delete halprog 110723 put back in? 
			NSString *str = @"";
			str = [str stringByAppendingString:lastInitials];
			NSString *str2 = [NSString stringWithFormat:@":%@:%d", wordzSetNameL1, score];
			str = [str stringByAppendingString:str2];
			// open and write to new high scores file
			[str writeToFile:self.highScoreFilename atomically:YES  encoding:NSUnicodeStringEncoding error:nil];
			rank = 1;
			lastRank = rank;               //101224 next two lines also. special case - 1st win after clear file.
			[winnerSound play];
//		    NSLog(@"\n\nPlay winnerSound place 1.\n"); 	// 110725
            
            [scoreString release];        // 110323
			[self showHighScores];
			
		}
		else {
//			NSLog(@"\nExisting high score file, contains %@.", scoreString);
			
			NSArray *rows = [scoreString componentsSeparatedByString:@"\n"];
			NSEnumerator *enumerator = [rows objectEnumerator];
			id element;
			int count = 0;
			NSString *fileString = @"";
			while ((element = [enumerator nextObject])) {
				NSString *str = (NSString *)element;
				NSArray *values = [str componentsSeparatedByString:@":"];
				if ([values count] < 3) {
					continue;
				}
				count++;
				NSScanner *scoreScanner = [NSScanner scannerWithString:[values objectAtIndex:2]];
				int scoreValue;
				[scoreScanner scanInt:&scoreValue];
				if (score <= scoreValue && rank > 10) {
					NSString *mystr = @"";
					mystr = [mystr stringByAppendingString:lastInitials];
					NSString *str2 = [NSString stringWithFormat:@":%@:%d", wordzSetNameL1, score];
					mystr = [mystr stringByAppendingString:str2];
					
					fileString = [fileString stringByAppendingString:mystr];
					fileString = [fileString stringByAppendingString:@"\n"];
					rank = count;  
                    
                    /*
 NSLog(@"count <= scoreValue and rank > 10, so count is %d, scoreValue %d, rank is %d and fileString is now %@.",
							count, scoreValue, rank, fileString);
                    */
					count++;
				}
				if (count < 11) {
					fileString = [fileString stringByAppendingString:str];
					fileString = [fileString stringByAppendingString:@"\n"];
//					NSLog(@"count < 11, fileString is now %@.", fileString);
                    
                    /*
NSLog(@"count <= scoreValue and rank > 10, so count is %d, scoreValue %d, rank is %d and fileString is now %@.",
                          count, scoreValue, rank, fileString);
                    */                    
				}
			}
			if (count < 10 && rank > 10) {
				NSString *str = @"";
				str = [str stringByAppendingString:lastInitials];
				NSString *str2 = [NSString stringWithFormat:@":%@:%d", wordzSetNameL1, score];
				str = [str stringByAppendingString:str2];
				
				fileString = [fileString stringByAppendingString:str];
//				NSLog(@"count < 10, rank > 10, fileString now %@.", fileString);
				count++;
				rank = count;
                
                /*
                NSLog(@"count <= 10 and rank > 10, so count is %d, rank is %d and fileString is now %@.",
                      count,  rank, fileString);
                */                
                
			}
			[fileString writeToFile:self.highScoreFilename atomically:YES  encoding:NSUnicodeStringEncoding error:nil];
//			NSLog(@"\n====>>>>>>>New scoreString =  %@", scoreString);
            
            /* also not used, not localized.
            
			if (rank < 11) {
				msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\nYou got a high score!\nYour rank is #%d!", rank]];
			}
             
            Note: when games ends and rank is > 10, still show high scores. should suppress this. 
             
             
		    */  
            
            [scoreString release];        // 110323   
		}
		// end part three // 
		
//		lastRank = rank; // static analysis error -- this is a no-op as the values are always the same..
//		NSLog(@"\n\nPlay winnerSound place 2.\n"); 			
		[winnerSound play];
            
            if (rank < 11) {   // supress top score display for non-top-10 result. 110725  last breakpoint!! 
            
            [self showHighScores];
                
            }
		
		// lastRank = 15; // skip file for now 
		
		isClearing = FALSE;

			
	}
// 	NSLog(@"WHat is here? "); answer: code here is executed for every tile click, 
	// both for dead tiles and live tiles.

		
	} // end of if easyFLAG == 0 else section for easyFLAG  == 1 		// 101228
} // end of tileClicked routine 

// begine part three start //
/*

 this common event handler -- return from alert window -- at first uses the title to distinguish between
 the title of the alert that will ask for the initials of a high scorer, and the alert that is 
 saying "you are a winner" (which simply ignores the response...
 
 titles for alert windows are:
 
 @"Wordz Lianxi Clear Scores"  alert3 -- "clear high scores?"
 @"Wordz Lianxi Clear Scores"  alert4 -- "high scores are cleared"
 
 @"Wordz Lianxi Winner!"       alert
 @"Enter Your Initials"        alert1
 
 will add an instance variable BOOL alert4ClearScores with values 0 unless we are asking to clear scores.
 if alert4ClearScores, then if index is not 
 
 note two methods called "alertView" -- this one has second arg: NSIntger

*/



- (void) alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger) index {
	

//    NSLog(@"In alertView didDismissWithButtonIndex etc.... ");
//	NSLog(@"index is %d", index); 
	NSString *t = [alert title];
    
//	NSLog(@"Alert title is now %@:", t);   // 100909a 
	
    
    /*
	if (isClearing) {
		NSLog(@"\n\tHave isClearing!!!");
	} else {
		NSLog(@"\n\tDo Not Have isClearing!!!!!!!!");
	}
     */
    
    
	if ((isClearing ) && (index == 0)) {
//		NSLog(@"they clicked cancel!!!!!");
		return;
	}
		if ((isClearing ) && (index == 1)) {
//		NSLog(@"they clicked OKAY !!!!!");
		
		//      -------- so clear it....
		NSString *str = @"";
		[str writeToFile:highScoreFilename atomically:YES encoding:NSUnicodeStringEncoding error:nil];
		
		
		
		UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:wlClearScoresHDRString 
														 message:wlScoresRClearedString
														delegate:self  // self to use delegate  
											   cancelButtonTitle:doneString 
											   otherButtonTitles: nil];
			
			[alert4 show];
			[alert4 release];
			return;
		}
		//      --------
	
	// not a high score
	if (lastRank > 11) {
		return;
	}
	
	// this code not used either....  should delete... 
    
	NSComparisonResult result = [t compare:@"Wordz Lianxi Winner!"];
	if (result != NSOrderedSame) {
		// maybe never get hree as a result of using modal window... moved 101223
		// 
		// not going to use alerts to get initials, so can skip these tests. 101219
		// need to change to make sure modal window used to get initials in the right place 101219
		//
		//  UITextField *textField = [alert textFieldAtIndex:0];
		//  NSString *initials = [textField text];
		//		self.lastInitials = initials;  // 101219 this should be already set by modal window... 
//		NSLog(@"Now in winner routin with existing file?? not sure.. ");
		
		
		// set the initials in the score table
		NSString *scoreString = [[NSString alloc] initWithContentsOfFile:self.highScoreFilename];
		NSArray *rows = [scoreString componentsSeparatedByString:@"\n"];
		NSEnumerator *enumerator = [rows objectEnumerator];
		id element;
		int count = 0;
		NSString *fileString = @"";
		while ((element = [enumerator nextObject])) {
			NSString *str = (NSString *)element;
			NSArray *values = [str componentsSeparatedByString:@":"];
			count++;
			if ([values count] < 3) {
				fileString = [fileString stringByAppendingString:str];
				fileString = [fileString stringByAppendingString:@"\n"];
				continue;
			}
			if (count == lastRank) {
				NSScanner *scoreScanner = [NSScanner scannerWithString:[values objectAtIndex:2]];
				int scoreValue;
				[scoreScanner scanInt:&scoreValue];
				
				//NSScanner *setNameScanner = [NSScanner scannerWithString:[values objectAtIndex:1]];
				//NSString *setNameValue;
				// [setNameScanner scanString:setNameValue];
				
				fileString = [fileString stringByAppendingString:lastInitials];
				fileString = [fileString stringByAppendingString:[NSString stringWithFormat:@":%@:%d\n", wordzSetNameL1, scoreValue]];				
			}
			else {
				fileString = [fileString stringByAppendingString:str];
				fileString = [fileString stringByAppendingString:@"\n"];
			}
		}
//		NSLog(@"ready to write file.... hal 100820.");
		[fileString writeToFile:self.highScoreFilename atomically:YES encoding:NSUnicodeStringEncoding error:nil];

		// don't popup high scores automatircally
		//[[self navigationController] pushViewController:highScoreViewController animated:YES];
		/*
		[highScoreViewController loadScores:self.highScoreFilename];
		[highScoreViewController setTitle:self.highScoreTitle];
		if (lastRank < 11) {
			// highlight the score
			[highScoreViewController highlightScore:lastRank];
		}
		*/ 
		[highScoreSound play];
//		NSLog(@"\n\nPlay highScoreSound place 1.\n"); 
		// test vor version 1.98B start highschore pop up?
        
        [scoreString release];        // 110323
		[self showHighScores]; // wrapped around the axel???.....  remove hal debug 100922
		
	}
	else {
		isClearing = FALSE;
		/*                              101224 - moving in changes for usernameVC
		
		UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Enter Your Initials" 
														 message:@"Initials"
														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert1 addTextFieldWithValue:lastInitials label:@"Initials"];
		UITextField *textField = [alert1 textFieldAtIndex:0];
		textField.keyboardType = UIKeyboardTypeAlphabet;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
		[alert1 show];
		[alert1 release];
										101224  - end of changes for usernameVC
		 */ 
	}
}
// part three end //





/*	
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isPlaying) {
		UITouch *touch = [[event allTouches] anyObject];
		
		float distanceMoved =  ([touch locationInView:touch.view].x +touchOffset) ; 
		
		 paddle.center.x;
		 float newX = paddle.center.x + distanceMoved;
		 if (newX > 30 && newX < 290)
		 paddle.center = CGPointMake( newX, paddle.center.y );
		 if (newX > 290)
		 paddle.center = CGPointMake( 290, paddle.center.y );
		 if (newX < 30)
		 paddle.center = CGPointMake( 30, paddle.center.y );
	}
}

*/


-(void)gameLogic{
	//	ball.center = CGPointMake(ball.center.x+ballMovement.x,
	//							  ball.center.y+ballMovement.y);
	
}


// saving state will require whole board save, scores, tiles matched and not matched, etc.
// need match[] for 0 to 35? 

// NSString *kLivesKey = @"IVBrickerLives";
// NSString *kScoreKey = @"IVBrickerScore";

- (void)saveGameState {
	//	[[NSUserDefaults standardUserDefaults] setInteger:lives forKey:kLivesKey];
	//	[[NSUserDefaults standardUserDefaults] setInteger:score forKey:kScoreKey];
}

- (void)loadGameState {
	//	lives = [[NSUserDefaults standardUserDefaults] integerForKey:kLivesKey];
	//	livesLabel.text = [NSString stringWithFormat:@"%d", lives];
	//	score = [[NSUserDefaults standardUserDefaults] integerForKey:kScoreKey];
	//	scoreLabel.text = [NSString stringWithFormat:@"%d", score];
	
	
}



#pragma mark -
#pragma mark Controls - Settings, InfoLight-about  

- (IBAction)nextSet { 
	// just increment the set number, mod max set number, and update kSetToUse in user defaults.
	// effect will be on next newgame...
	gSetIDX++;
	if (gSetIDX > gMaxSet) {
		gSetIDX = 1;
	}
	gSetID = setID[gSetIDX];
//	NSLog(@"\tWrote out SetID as: %d", gSetID);	
	[[NSUserDefaults standardUserDefaults] setInteger:gSetID forKey:kSetToUse];	
	
	
	/*
	int sIDX = [theSIDXTextfield.text intValue]; 
	if ((sIDX > 0)  && ( sIDX < 4)) {
		sidxSetting = sIDX;
		[[NSUserDefaults standardUserDefaults] setInteger:sIDX forKey:kSetToUse];
		NSLog(@"\tWrote out sidx as: %d", sidxSetting);	
	*/	
	
	// now start new game!
	[self createNewGame];
	
}

- (IBAction)nextMode { // nextStyle (now prev set)
	
	/*
	
	 if WP, make WW
	 if WW make PP
	 if PP make WP
	 
	 
	 then save to defaults
	 
	-- old end of comments --- 
	 
	if ([matchMode isEqualToString: @"PP"]) {
		matchMode = @"WP";
	}
	else if 
		([matchMode isEqualToString: @"WP"]) {
		matchMode = @"WW";
	}
	else if 
		([matchMode isEqualToString: @"WW"]) {
		matchMode = @"PP";
	}
	else {
		matchMode = @"WP";
	}

	[[NSUserDefaults standardUserDefaults] setObject:matchMode forKey:kGameMode];
	
	NSLog(@"\tWrote out matchMode as: %@", matchMode);	

	old 'next style' feature removed.  change to 'previous set' modeled on next set routine above 101202
	 
	*/
	
	gSetIDX--;
	if (gSetIDX < 1) {
		gSetIDX = gMaxSet;
	}
	gSetID = setID[gSetIDX];
//	NSLog(@"\tWrote out SetID as: %d", gSetID);	
	[[NSUserDefaults standardUserDefaults] setInteger:gSetID forKey:kSetToUse];	
	
	
	
	
	// now start new game!
	[self createNewGame];
	
}

- (IBAction)nextLang {
	
	/*
	 
	 if L1 set to L2 (from tilez)
	 if L2 set to L1 
	 
	
	 then save to defaults
     
     ver 3 change: kL1 => k_L1  (constant to variable) 110715
     not yet working 110716 -- 
	 
	   
    NSLog(@"in next lang.  picture lang is >%@<", pictureLang); // halprog	
    NSLog(@" we have k_L1 of >%@.", k_L1);
    */ 
//    NSLog(@"in next lang.  picture lang is >%@<", pictureLang); // halprog	
    
	if ([pictureLang isEqualToString: k_L1]) {
		pictureLang = kL2;
	} else if ([pictureLang isEqualToString: kL2])  {
  
        
//         [pictureLang initWithString:k_L1];  crashes
        
	 	pictureLang = k_L1;		
        
//        [pictureLang stringWithString:k_L1];  //         crashes
//        NSString pictureLang = [NSString stringWithString:k_L1];
        
        
//        [k_L1 initWithString:@"EN"];        or otherwise set pictureLang with init... make it mutable, argh... halprog 110716
        
	} else {
		pictureLang = kL2;
	}

	[[NSUserDefaults standardUserDefaults] setObject:pictureLang forKey:kLangToTest];

//	NSLog(@"\tWrote out pictureLanguage as: %@", pictureLang);	

    // halprog
//    NSLog(@"heading to createNewGmae.  picture lang is >%@<", pictureLang);
//    NSLog(@" we have k_L1 of >%@.", k_L1);
    
    
	// now start new game!
	[self createNewGame];
	
}
// new routine 101219 -- added 101223 

- (IBAction)getUserName {
	// will put up modal window to get username:
	
	UsernameViewController *controller =
	[[UsernameViewController alloc] 
	 initWithNibName:@"UsernameViewController" bundle:nil];	
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//	controller.modalPresentationStyle = UIModalPresentationCurrentContext;
	controller.modalPresentationStyle = UIModalPresentationFormSheet;
	//	controller.modalPresentationStyle = UIModalPresentationFullScreen;
	controller.delegate = self;
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}




- (IBAction)settings { 
// will put up modal info display window	

	SettingsViewController *controller =
	 [[SettingsViewController alloc] 
	 initWithNibName:@"SettingsViewController" bundle:nil];
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	controller.modalPresentationStyle = UIModalPresentationCurrentContext;
	
// Page Sheet works but doesn't show all... trying current context...	
	
//	controller.modalPresentationStyle = UIModalPresentationFormSheet;

//	controller.modalPresentationStyle = UIModalPresentationPageSheet;
//	controller.modalPresentationStyle = UIModalPresentationFullScreen;
	
	controller.delegate = self;
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
		
}

//  newroutine 101219 replace bad calls
- (void) usernameViewControllerDidFinish:(UsernameViewController *)controller {
	
//	NSLog(@"In usernameViewControllerDidFinish....");
	
	
	
	if (controller.wlUserName) {
		lastInitials = controller.wlUserName;
		[[NSUserDefaults standardUserDefaults]
		 setObject:lastInitials forKey:kLastUserName];
		[lastInitials retain];
		
        statusLabel.text = [usernamePt1String stringByAppendingString:lastInitials];       /// final fix
        statusLabel.text = [statusLabel.text stringByAppendingString:usernamePt2String];   /// final fix		
        
		
		//self.highScoreFilename = [self.highScoreFilename stringByAppendingString:documentsDirectory];
		
		
		
		// put in lines here to save this in settings ... maybe next version
	}
	
//	NSLog(@"Back from setUserName with username of %@.", lastInitials);
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void) settingsViewControllerDidFinish:(SettingsViewController *)controller {
	
//	NSLog(@"Here in settingsViewControllerDidFinish of wl1_2vc.m   ALPHA");
	

	/* -- this logic seemed to be supressing the immediate use of the new settings.... 100912
	if (controller.mmSetting) {
		matchMode = controller.mmSetting;
		[[NSUserDefaults standardUserDefaults]
		setObject:matchMode forKey:kGameMode];
		[matchMode retain];
	}
	if (controller.plSetting) {	
		pictureLang = controller.plSetting;
		[[NSUserDefaults standardUserDefaults]
		setObject:pictureLang forKey:kLangToTest];
		[pictureLang retain];
	}
	 */
	
//	if (controller.useAlphaSetting) {	
		useAlpha = controller.useAlphaSetting;
		[[NSUserDefaults standardUserDefaults]
		 setInteger:useAlpha  forKey:kUseAlpha];
//		[useAlpha retain]; // test 110309
		
//		NSLog(@"Wrote out useAlpha as: %d. 1 CHARLIE", useAlpha);
//	}
	
//	if (controller.sidxSetting) {	
		gSetIDX = controller.sidxSetting;
		[[NSUserDefaults standardUserDefaults]
		 setInteger:gSetIDX forKey:kSetToUse];
		//		[sidxSetting retain]; // test 110309
		
//		NSLog(@"Wrote out sidx as: %d.  2 BRAVO", gSetIDX);
		
//	}
// set preventEM
    
    
//	if (controller.preventEMSetting) {	              // update very time -- zero is a VALUE, not an indicator of change!!! 11-04-06
		preventEM = controller.preventEMSetting;
		[[NSUserDefaults standardUserDefaults]
		 setInteger:preventEM  forKey:kPreventEM];
        //		[useAlpha retain]; // test 110309
		
//		NSLog(@"Wrote out preventEM as: %d. 1 DELTA", preventEM);
//	}
    
    
// end set preventEM    
	
	
	if (controller.plSetting) {	
		pictureLang = controller.plSetting;
		[[NSUserDefaults standardUserDefaults]
		 setObject:pictureLang forKey:kLangToTest];
		[pictureLang retain];
	}
	
	
	// errors? these are n't used now... 
	
	/*
	matchMode = controller.mmSetting;
	pictureLang = controller.plSetting;
	
	next two are set above. and put into user defaults (as they were in settinggsviewcontroller... redundant! ?  
	 
	gSetIDX = controller.sidxSetting;
	useAlpha = controller.useAlphaSetting;
	*/
	
//	NSLog(@"Back from Settings with GameMode of %@ and PicLang of %@ and GSetIDX of ", matchMode, pictureLang, gSetIDX);
	
//	NSLog(@"Back from Settings with Alpha of %d and GSetIDX of %d", useAlpha, gSetIDX);
	
	
	
	[self dismissModalViewControllerAnimated:YES];			
}

- (IBAction)about { // open about window as modal view? ver 3.05 : play movie
	
    //	NSLog(@"about to open about window...");
	AboutWLViewController *controller2 =
	[[AboutWLViewController alloc] initWithNibName:@"AboutWLViewController" bundle:nil];
	
	controller2.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	controller2.modalPresentationStyle = UIModalPresentationPageSheet;   // 540 x 620 ?? form sheet  vs. page sheet  768 x 768  ??
	
	controller2.delegate = self;
	
	[self presentModalViewController:controller2 animated:YES];
	[controller2 release];
	
	
	
}

- (IBAction)demo {    // ver 3.05
	
    //	NSLog(@"about  to open demo window...");
	DemoViewController *controller2 =
	[[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
	
	controller2.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	controller2.modalPresentationStyle = UIModalPresentationPageSheet;
	
	controller2.delegate = self;
	
	[self presentModalViewController:controller2 animated:YES];
	[controller2 release];
	
	
	
}

-(void)aboutWLViewControllerDidFinish:(AboutWLViewController *)controller {
//	NSLog(@"Back from About modal window.");
	[self dismissModalViewControllerAnimated:YES];			
}

-(void)demoViewControllerDidFinish:(DemoViewController *)controller {
    //	NSLog(@"Back from Demo modal window.");
	[self dismissModalViewControllerAnimated:YES];			
}


#pragma mark -
#pragma mark High Scores Etc

// high scores start
- (IBAction)showHighScores { 
	// will put up modal info display window	
	
//	NSLog(@"In showHighScores with filename %@.", highScoreFilename);
	HighScoresViewController *controller =
	[[HighScoresViewController alloc] 
	 initWithNibName:@"HighScoresViewController" bundle:nil];
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//	controller.modalPresentationStyle = UIModalPresentationCurrentContext;
	controller.modalPresentationStyle = UIModalPresentationFormSheet;
	
	controller.delegate = self;
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}

- (void) highScoresViewControllerDidFinish:(HighScoresViewController *)controller {
	
	
//	NSLog(@"Back from high scores. ");
	
	[self dismissModalViewControllerAnimated:YES];	
	
	
}


// high scores end


- (IBAction)clearHighScores { 
	// will put up modal info display window	
	
	/* - (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate 
cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle 
otherButtonTitles:(NSString *)otherButtonTitles, ...;
	*/
	
	
//	NSLog(@"In clearHighScores with filename %@.", highScoreFilename);

	isClearing = TRUE; // 100909 
	
	UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:wlClearScoresHDRString
													message:wlAskClearScoresString
													delegate:self  // self to use delegate  
										   cancelButtonTitle:cancelString 
	
										   otherButtonTitles:OKString, nil];
	/* 
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wordz Lianxi Winner!" 
	 message:msg
	 delegate:self  // self to use delegate  
	 cancelButtonTitle:@"OK" 
	 otherButtonTitles:nil];
	 
	 
	 
	*/
	
	
	
//	UIAlertView *alert = [[UIAlertView alloc] init
															
	[alert3 show];	
	[alert3 release];
	
	
} // end clearHighscores -- form button...

// unline other alertView routine, this one has actionSheet not alrert as object returning... is this used? 
/*
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"ok..");
} else {
	NSLog(@"Cancel..");
}
}
*/  

#pragma mark -
#pragma mark Orientation and Memory Management

// Override to allow orientations other than the default portrait orientation.

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
//	NSLog(@"in Dealloc routine...");
	[statusLabel release];
	[timeLabel release];
	[missedLabel release];
	[modeLabel release]; //110208
    

	
	[pauseButton release];
	[setReviewModeButton release];	
	[topScoresButton release];
	[clearScoresButton release]; // new100821b
	[nxwGameButton release];	
	[hintButton release];	// new 101202
	[wordzSetLabelNM release];
	// release sound files too
	[correctSound release];
    [incorrectSound release];
    [winnerSound release];
    [nxwGameSound release];
    [highScoreSound release];
    [hintSound release];	
	
	[fcImageView release];
	[timer release];
	[highScoreFilename release];
	[highScoreTitle release];
	[lastInitials release];
		
	
    [super dealloc];
}	
	
@end
