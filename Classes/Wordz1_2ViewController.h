//
//  Wordz1_2ViewController.h
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//
//  110404
//
//  110714 VERSION 3.00 START
//  added k_L1 as  NSString to header file to hold global var for the current selected UI / L1 language - en/fr/de/es/zh/it
// 
//  CHanges for original / base version:  FR4EN.
//          Image Files:  prior version had PNG files for FR_Word, , JPG files for EN_word, PIC_pic files
//                        will switch to all PNG FILES.  must update database.
//
//  110903  changes for dual layer flip flipDuration float added for timing of flip.
//  111120 -- new URL for help / goto web site. in About and Settings.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "SettingsViewController.h"
#import "HighScoresViewController.h"  // new 100821
#import "AboutWLViewController.h"     // new 100911 
#import "UsernameViewController.h"    // new 101219 
#import "DemoViewController.h"     // new 110929 

#import <sqlite3.h> // 100905 import sqlite framework

@class SoundEffect;

@interface Wordz1_2ViewController : UIViewController 
	<SettingsViewControllerDelegate, HighScoresViewControllerDelegate, 
	 UsernameViewControllerDelegate,                                    // added 101219 
AboutWLViewControllerDelegate,  DemoViewControllerDelegate, UIAlertViewDelegate> {	// added about delegate 100911 and Demo delegate 120829

		 
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *missedLabel;
	IBOutlet UILabel *modeLabel;  // 110208 	 
		
	IBOutlet UIButton *hintButton;	 // 101202
	IBOutlet UIButton *pauseButton;
	IBOutlet UIButton *topScoresButton;	
	IBOutlet UIButton *clearScoresButton;	
	IBOutlet UIButton *nxwGameButton;		
	IBOutlet UIButton *nextSetButton;		
	IBOutlet UIButton *nextStyleButton;	// changed to mean previous set 101202
	IBOutlet UIButton *nextLangButton;			
		 
	IBOutlet UIButton *setReviewModeButton;			 //101228		 
	IBOutlet UIButton *setUsernameButton;			 //101223		 
	
	IBOutlet UILabel *wordzSetLabelNM; 
		
	IBOutlet UIImageView *fcImageView;
    IBOutlet UIImageView *imageView200x200;     //110828 gestures
    
    int  kEnableSwipes;                         //110828 gestures 	
    BOOL bEnableSwipes;                         //110828 gestures defaults in settings bundle
	
	NSString *databaseName, *databasePath;	//100905 
				
	NSString *highScoreFilename;
	NSString *highScoreTitle;
	NSString *lastInitials;		
	
	// top left corner of image at 1,1 location on tile board	
#define XBOARDORIGIN 358
#define	YBOARDORIGIN 93
#define TILESIZE 100 
	
	
		float touchOffset;
	
		BOOL isPlaying, needsNewGame;
		BOOL isClearing, hasLoadedDB;   // 100911 hasLoadedDB
		BOOL firstGame;					// 100918  all other create games will release the image arrays etc. 
		int playingCurrentSetID;        // 100911 which set currenlty using -- changed only in setup. starts at 1.
		
		
// 	CADisplayLink *theTimer;
		
		NSTimer *timer;    // matho example
		int time, missed, score, hintCounter,  lastRank;  // rank now local var 100820
		int pauseState; // 0 not paused, 1 paused

         
// localized strings start here         
		 NSString *pauseString, *resumeString;
		 NSString *easyString, *noEasyString;
         NSString *usernamePt1String, *usernamePt2String, *gamePausedString, *yesAisBString, *sorryAnotBneedCString;
         NSString *sorryNOEMString;
         NSString *endReviewGameString, *endOfGameMessageString, *wlClearScoresHDRString, *wlScoresRClearedString, *doneString;
         NSString *wlAskClearScoresString, *cancelString, *OKString;
         
         NSString *noExactMatchAllowedMsg;   // 110406  for improved errors if this feature enabled.
//         NSString *condEMmsg;                // set this to space or noEact match message whenever preventEM changes.  
		 
		

	
	
#define TILES_WIDTH  6
#define TILES_HEIGHT 6
	
	int lastTouchLocX, lastTouchLocY;
	int lastTileX, lastTileY;
	
	
	
	/* do a define for ENGLISH as 1, simplifed CHINESE as 2, Spanish, french etc
	 so we can make all strings arrays and use chosen language? for now just english...
	 
	 */
	
	UIImageView *imageBase; 	
	
	
	UIImageView *tiles[TILES_WIDTH][TILES_HEIGHT];

		
		
	
	NSString *tileSaves[TILES_WIDTH][TILES_HEIGHT]; //  name of front picture
	
	UIImage *imageBack; // just image to put into image view when flipped
	
	NSString *tileBackPicImageNM; // file name of back image
	
	int tileState   [TILES_WIDTH][TILES_HEIGHT]; // 0 - face up; 1 - back up
	int tilePointer [TILES_WIDTH][TILES_HEIGHT]; // points to index into array of tile info
	int selPointer ; // holds current index into array for tile selected via [x][y]
	
		int easyFLAG ;  // set to 1 for sequential arrangement with tiles board 
						//   same as fcseqn list --  use second array in normal case
						//   but set flag to 1, not defaut of zero, to assist debugging
					    // easyFLAG switched for use as "REVIEW MODE". version 2.00 
		 
		 int checkImageFileNames ;  // if 1, all image files names will be checked to see if image file is there -- nslog to report errors, pluse alert.
									// also force to use all lower case chars in file names.  110118 version 2.03
		 // 110125 file check flag set in implementation file. hard coded. 
		 
		 
		
	//  NSString *brickTypes[4];
	//  declare set level data items
	NSString *wordzSetNameL1;
	NSString *wordzSetNameL2;
	NSString *wordzSetType;
	NSString *wordzSetLang1;
	NSString *wordzSetLang2;
	NSString *wordzSetLangDesc1;
	NSString *wordzSetLangDesc2;
	
		 // for multi-set implementation from DB: 110911
		 
		 NSString *setNM[20];
		 int      setID[20];
	
		 // GLOBAL SET NUMBER USED TO GET TILES FOR CURRENT CHOSEN SET  100905 hal
		 int gSetIDX;  // 1 to 3 for now; 1 -16 for production??? 
		 int gMaxSet;  // set by code but should be 3 for now, 16 for shipping / $$ version
		 int gSetID;   // for now all code assumes setID(gSetID) = gSetIDX such that 1 = 1. 2 = 2. 3 = 3. 
		 // wont work if three sets are 6,7 and 8!! need to work on this hal prog 100912 
		
		 int useAlpha;  // settings:  zero value means FLIP tiles (show back) all others reset alpha to .7
         int preventEM; // settings:  zero of exact matches allowed; set to non-zero number to prevent exact matches   110404 
		 
		 int randSetID;   // will be set number 17 for this app. 16 sets active in database -- will make number sets read in from db + 1 // 110112 
		 
		 
	// begin core tilez data -------------------------------------------- core tilez data
	//  declare tile data   -- max was set at 144 for 4 sets, move to 288 for 8 sets; 576 for 16
	NSString *tileLangID_db[576]; // language for this tile 
	NSString *tileNM_db[576]; //  in message, tile name...  
		
	NSString *wordTXT_db[576]; // in msg -- shows pretty value
	int pictureIND_db[576]; // could check before looking for picfileNM, in future 1 Is Present
	// even use wordTXT to create a pic on the fly hehehe
	NSString *matchingTileNM_db[576]; //  matching tile name
	int matchingTileIDX_db[576]; // direct index to matching tile in origianal array 
	
	NSString *tileWordPicImageNM_db[576]; // picture of the word in lang TileLangID
	NSString *tilePicPicImageNM_db[576]; // picture representing the word
		 
	NSString *tileHint_db[576]; // use refInfoTxt field for hints   101216	
		 
		 

	//   end core tilez data -------------------------------------------- core tilez data		 
		 
		 // begin working set of core tilez data -----------------   working set --  core tilez data
		 //  declare tile data for 36 tiles. read from xml file in future.
		 NSMutableString *tileLangID[36]; // language for this tile 
		 NSMutableString *tileNM[36]; //  in message, tile name...  
		 
		 NSMutableString *wordTXT[36]; // in msg -- shows pretty value
		 int pictureIND[36]; // could check before looking for picfileNM, in future 1 Is Present
		 // even use wordTXT to create a pic on the fly hehehe
		 NSMutableString *matchingTileNM[36]; //  matching tile name
		 int matchingTileIDX[36]; // direct index to matching tile in origianal array 
		 
		 NSMutableString *tileWordPicImageNM[36]; // picture of the word in lang TileLangID
		 NSMutableString *tilePicPicImageNM[36]; // picture representing the word
		 NSMutableString *tileHint[36]; // 101216 hal
		 
		 //   end working set of core tilez data ------------------  working set -- core tilez data		 
		 
		 
		 
		 
	// declare array that randomizes static data array by providing index value 
	// for buckets 1-36.  hence all picture attributes such as 
	
	int tindex[36]; // holds values 0 to 35 in random order -- for order to fill tile board
	int fcseqn[36]; // also holds values 0 to 35 random order -- to walk throuhg cards to 
		// match
	
		
		
	/*  declare game level parameters:

	 change game mode to   
	 
	 should are now just two modes, where you flash cards are CN or EN plus pictures, and you must 
	 match to EN or CN plus pictures. 
	
	 FC lang is always opposite of tileboard lang. pictures always included in both sets.

	 
	 So always two tiles per prompt? yes. keep it simple.
	 
	 
		Match	Prompt		Answer
		Mode	Picture		Picture
		----	-------		-------

		WP EN	Chinese WD	Picture and English WD
		WP CN	English WD	Picture and Chinese WD

	 
	 */
	NSString *gameLanguage; //  CN or EN or whatever. get from phone?
	// 110714 
         
         
         // 110814 PE_CHANGE_ONLY
         
         UIImage *resumeImage; // button images that change.  110813  -- but added 110913 
         UIImage *pauseImage, *reviewImage, *playImage;
         
         
         
         
         
    //     NSMutableString *k_L1;  // will hold the value of the learner's language -- UI. replaces old kL1 constant in code. kL2 is fixed (FR in this case).
    //     NSMutableString *K_L1_LangPreference; // holds UI or last ui value -- de/en/fr/it/es/zh
      
         NSString *k_L1;
         NSString *k_L1_LangPreference;
         NSString *LLString;
         NSString *LXString; // debug new plist entry
         Boolean enable_swipes;
         
         
	
		
	//	NSMutableString *matchMode; // either W2W or W2P.
	//	NSMutableString *pictureLang;  // L1, L2 if matchMode is W2P; otherwise undefined
	
		//these two should drive things. will rename the ones in the settings logic...
	NSString *matchMode; // either PP, CN, EN
         
         
//	NSMutableString *pictureLang;  // set by gamelogic for use in loading arrays.  // change to Mutable??
    NSString *pictureLang;  // set by gamelogic for use in loading arrays.  // change to Mutable??

    NSString *useAlphaString; // used to set FLIP or NO -> useAlpha as 0 or non-zero
		 
	
	// Flash Card is the name of the bottom left tile to mathch.
	// note  fcImageView is UIImageView object we will update as the flash card to match	
	
	NSString *fcImageNM ; //  will hold the name of the displayed tile the player is trying to match
	
	//  fcPointer starts at 0, and increments to 35 to end game
	//  fcPtsArrayIDX is the place that the current fcPointer points to in the teilArrays
	int fcPointer ; 	// this points into the Array of tiles, the current Flash Card shown the  user
	int fcPtsArrayIDX; 	// value of tindex[fcPointer] said another way
		
		int amax, amin, anew;
		int arrayPTR;
		BOOL isNew;
		
         float flipDuration;   //110903
		
	// declare remaining global arrays		
	//	NSString *brickTypes[4];
	
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *missedLabel;

@property (nonatomic, retain) IBOutlet UILabel *modeLabel; // 110208

@property (nonatomic, retain) IBOutlet UIButton *hintButton;


@property (nonatomic, retain) IBOutlet UIButton *pauseButton;
@property (nonatomic, retain) IBOutlet UIButton *topScoresButton;
@property (nonatomic, retain) IBOutlet UIButton *clearScoresButton;
@property (nonatomic, retain) IBOutlet UIButton *nxwGameButton;
@property (nonatomic, retain) IBOutlet UIButton *nextSetButton;
@property (nonatomic, retain) IBOutlet UIButton *nextStyleButton;
@property (nonatomic, retain) IBOutlet UIButton *nextLangButton;

@property (nonatomic, retain) IBOutlet UIButton *setUsernameButton;     //  101223
@property (nonatomic, retain) IBOutlet UIButton *setReviewModeButton;   //  101228



@property (nonatomic, retain) IBOutlet UILabel *wordzSetLabelNM;

@property (nonatomic, retain) SoundEffect *correctSound;
@property (nonatomic, retain) SoundEffect *incorrectSound;
@property (nonatomic, retain) SoundEffect *winnerSound;
@property (nonatomic, retain) SoundEffect *nxwGameSound;
@property (nonatomic, retain) SoundEffect *highScoreSound;

@property (nonatomic, retain) SoundEffect *hintSound;   // 101216


@property (nonatomic, retain) IBOutlet UIImageView *fcImageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView200x200;    // 110828 gestures

@property (nonatomic, retain) NSTimer *timer;

// @property (nonatomic, retain) BOOL *isClearing;

@property (nonatomic, retain) NSString *highScoreFilename;
@property (nonatomic, retain) NSString *highScoreTitle;
@property (nonatomic, retain) NSString *lastInitials;

-(void) settingsViewControllerDidFinish: 
(SettingsViewController *)controller;

-(void) highScoresViewControllerDidFinish: 
(HighScoresViewController *)controller;

-(void) aboutWLViewControllerDidFinish: 
(AboutWLViewController *)controller;

-(void) demoViewControllerDidFinish:                        // 110829
(DemoViewController *)controller;

- (void) usernameViewControllerDidFinish:                   // 101219
(UsernameViewController *)controller;


//  -(void)initializeTimer;  switch baack to simple timer 

// -(void)startPlaying;


-(void)saveGameState;
-(void)loadGameState;
-(void)initializeTileBoard;
-(void)initializeData;



-(void)tileClicked:(int)indexX withY:(int)indexY;

-(IBAction)settings;

-(IBAction)getUserName;								//101219

-(IBAction)setReviewMode;                              //101228

-(IBAction)showHighScores;

-(IBAction)clearHighScores;

-(IBAction)about;

-(IBAction)demo;   //110920

- (IBAction)createNewGame;

- (IBAction)giveHint;   //110101 left off 

- (IBAction)nextSet;
- (IBAction) nextMode; // nextStyle button --> now means prev set, 101202
- (IBAction) nextLang; // nextLang button (Language)

- (IBAction)pauseGame;


- (void)setupSounds;
- (void)setupDatabase;
- (void)checkAndCreateDatabase;
- (void)loadWorkingTilez;


// -(void)processFlip:(UIImageView *)tile;


@end

