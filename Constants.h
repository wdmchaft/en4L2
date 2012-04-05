//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//  101228 -- changes for 2.0 to enable "review mode"
//     
//  global constants
//  user Preferences to remmber between games
//  clone for version 3.00 fr4L2 110714
//  cloned to EN4L2 from FR4L2 110802
//  110810  change to dynammically determin which is L1 language for set titles. No New Constants needed. 

/* 
 
Completed updates for 3.01 -- 
  a) UI Base shows Pat Pending
  b) settings bundle added; L1 Tile Language settlable outside of app.
  
 
 need to add warning when EN is uses in lieu of some other UI language that is not avail. 
    alert  and set to english (e.g. "Warming: NO UI FOund for language XX. Loading English UI."

 UI selection is in viewDidLoad -- if becomse dynamic, would need to redo a lot of stuff...
 

 Known issues:
 
 erratta:  FR4ENv300 should have les lunettes de sole in set 13 tile 466.
 english on main FRENCH Ui screen: Time and Missed.
 add back FR as other lang choice in settings bundle
 
 Version 3.03 -- will fix all above, plus add Korean
 
 ---
 
 3.04: swipes. 
 3.05 animated flips. 110903.
 
 version 3.05 will ship with:
 
 a) animated flip
 b) new images for 288 pictures (or many of them)
 c) swipes enabled and controlled by settings bundle: double-tap,left/right swipe
 d) settings bundle support for alt L1 tile language, swipes
 e) new about screen (with icons decoded
 f) buttons with icons, not words, on main UI
 g) demo movie replacing written instructions
 
 e) replace text instructions with video??? now: additional video demo popup...
 
 110917 added japanese!!
 // begin pause state re-sync fix 110921 -- in main view controller. 

 
 
 
 */
 

#define	kGameMode	@"gameModePreference"	// WW or WP or PP 
//  matchMode in code right now...
#define	kLangToTest	@"langToTestPreference"	// EN or CN
//  pictureLang in code right now... 

#define	kUILangPref	@"UILangUIPreference"	// will be "UI" for phone country or or de/en/es/zh/it 
#define	kL1	@"EN"	// EN   in version 3.0 we use k-L1 as a string to hold the current UI / learner's language. so comment out and don't use.
#define	kL2	@"EN"	// language to learn.


//


#define	kLES	@"ES"	

#define	kLEN	@"EN"	

#define	kLCN	@"CN"	

#define	kLIT	@"IT"	

#define	kLDE	@"DE"	

#define	kLFR 	@"FR"	

#define	kLKR 	@"KR"	

#define	kLJP 	@"JP"	


#define kWLURL  @"https://sites.google.com/a/newportcoastsoftware.com/wordzlianxi/"        // @"www.wordzlianxi.com"

#define KITURL  @"http://itunes.apple.com/us/app/english-words-4-beginners/id455083740?ls=1&mt=8&partnerId=30&siteID=2777641" 

//

//

#define	kLastUserName	@"lastUserName"	          // 101219
//  default to AAA, prompt if they set... 

#define	kSetToUse  @"lastSetUsed" // to index into WSETZ table
//  setID(gSetIDX) = gSetID  in code right now... 
#define	kUseAlpha  @"useAlpha" // if zero then use FLIPPED Logic   v 2.14
//  setToAlpha  non-sero will fade to value of .7
#define	kPreventEM  @"preventEM" // if non-zero then prevent exact match  // v2.14
//  preventEM defaults to 0, allows exact match 
#define kHighScoresFileName @"/WordLianxiHS.txt" // 
// high score file name - only here
// new db name defines:  110714
#define kDatabaseNameL24CN @"wlllsEN4CNV300C.sl3"   // 
#define kDatabaseNameL24DE @"wlllsEN4DEV300D.sl3"   // 110806
#define kDatabaseNameL24EN @"wlllsEN4ENV300C.sl3"   // 110805 
#define kDatabaseNameL24ES @"wlllsEN4ESV300G.sl3"   // 
#define kDatabaseNameL24FR @"wlllsEN4FRV300C.sl3"   // 
#define kDatabaseNameL24IT @"wlllsEN4ITV300G.sl3"   // 110806
#define kDatabaseNameL24JP @"wlllsEN4JPV300A.sl3"   // ???   
#define kDatabaseNameL24KR @"wlllsEN4KRV300A.sl3"   //

// database file name only here
#define kSoftwareVersion @"version 3.18" //     
// shown on about page
#define kDatabaseVersion @"databaseVersionKey" // 
// shown on about page

