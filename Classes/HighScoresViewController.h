//
//  HighScoresViewController.h
//  Wordz1.2
//  Created by Newport Coast Software / Harry A. Layman of 8/21/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//     

#import <UIKit/UIKit.h>
// @protocol HighScoresViewControllerDelegate;
@class SoundEffect;

@protocol HighScoresViewControllerDelegate; // new 100821

@interface HighScoresViewController : UIViewController <UIAlertViewDelegate> {
id <HighScoresViewControllerDelegate> delegate;  // new 100821
	
	IBOutlet UILabel *num1Label;
	IBOutlet UILabel *num2Label;
	IBOutlet UILabel *num3Label;
	IBOutlet UILabel *num4Label;
	IBOutlet UILabel *num5Label;
	IBOutlet UILabel *num6Label;
	IBOutlet UILabel *num7Label;
	IBOutlet UILabel *num8Label;
	IBOutlet UILabel *num9Label;
	IBOutlet UILabel *num10Label;
	
	IBOutlet UILabel *initials1Label;
	IBOutlet UILabel *initials2Label;
	IBOutlet UILabel *initials3Label;
	IBOutlet UILabel *initials4Label;
	IBOutlet UILabel *initials5Label;
	IBOutlet UILabel *initials6Label;
	IBOutlet UILabel *initials7Label;
	IBOutlet UILabel *initials8Label;
	IBOutlet UILabel *initials9Label;
	IBOutlet UILabel *initials10Label;
	
	IBOutlet UILabel *difficulty1Label;
	IBOutlet UILabel *difficulty2Label;
	IBOutlet UILabel *difficulty3Label;
	IBOutlet UILabel *difficulty4Label;
	IBOutlet UILabel *difficulty5Label;
	IBOutlet UILabel *difficulty6Label;
	IBOutlet UILabel *difficulty7Label;
	IBOutlet UILabel *difficulty8Label;
	IBOutlet UILabel *difficulty9Label;
	IBOutlet UILabel *difficulty10Label;
	
	IBOutlet UILabel *score1Label;
	IBOutlet UILabel *score2Label;
	IBOutlet UILabel *score3Label;
	IBOutlet UILabel *score4Label;
	IBOutlet UILabel *score5Label;
	IBOutlet UILabel *score6Label;
	IBOutlet UILabel *score7Label;
	IBOutlet UILabel *score8Label;
	IBOutlet UILabel *score9Label;
	IBOutlet UILabel *score10Label;
	
//	IBOutlet UIButton *clearScoresButton;
	
	IBOutlet UIButton *doneButton;
	
	NSString *highScoresFilename;
	SoundEffect *clearScoresSound;
	
}

@property (nonatomic, retain) IBOutlet UILabel *num1Label;
@property (nonatomic, retain) IBOutlet UILabel *num2Label;
@property (nonatomic, retain) IBOutlet UILabel *num3Label;
@property (nonatomic, retain) IBOutlet UILabel *num4Label;
@property (nonatomic, retain) IBOutlet UILabel *num5Label;
@property (nonatomic, retain) IBOutlet UILabel *num6Label;
@property (nonatomic, retain) IBOutlet UILabel *num7Label;
@property (nonatomic, retain) IBOutlet UILabel *num8Label;
@property (nonatomic, retain) IBOutlet UILabel *num9Label;
@property (nonatomic, retain) IBOutlet UILabel *num10Label;

@property (nonatomic, retain) IBOutlet UILabel *initials1Label;
@property (nonatomic, retain) IBOutlet UILabel *initials2Label;
@property (nonatomic, retain) IBOutlet UILabel *initials3Label;
@property (nonatomic, retain) IBOutlet UILabel *initials4Label;
@property (nonatomic, retain) IBOutlet UILabel *initials5Label;
@property (nonatomic, retain) IBOutlet UILabel *initials6Label;
@property (nonatomic, retain) IBOutlet UILabel *initials7Label;
@property (nonatomic, retain) IBOutlet UILabel *initials8Label;
@property (nonatomic, retain) IBOutlet UILabel *initials9Label;
@property (nonatomic, retain) IBOutlet UILabel *initials10Label;

@property (nonatomic, retain) IBOutlet UILabel *difficulty1Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty2Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty3Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty4Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty5Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty6Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty7Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty8Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty9Label;
@property (nonatomic, retain) IBOutlet UILabel *difficulty10Label;

@property (nonatomic, retain) IBOutlet UILabel *score1Label;
@property (nonatomic, retain) IBOutlet UILabel *score2Label;
@property (nonatomic, retain) IBOutlet UILabel *score3Label;
@property (nonatomic, retain) IBOutlet UILabel *score4Label;
@property (nonatomic, retain) IBOutlet UILabel *score5Label;
@property (nonatomic, retain) IBOutlet UILabel *score6Label;
@property (nonatomic, retain) IBOutlet UILabel *score7Label;
@property (nonatomic, retain) IBOutlet UILabel *score8Label;
@property (nonatomic, retain) IBOutlet UILabel *score9Label;
@property (nonatomic, retain) IBOutlet UILabel *score10Label;

// @property (nonatomic, retain) IBOutlet UIButton *clearScoresButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) NSString *highScoresFilename; // 100821

@property (nonatomic, assign) id <HighScoresViewControllerDelegate> delegate; // new 100821


- (void)loadScores:(NSString *)filename;
- (void)highlightScore:(NSInteger)index;
// - (void)clearScores2;

- (void)clearTable;

// - (IBAction)clearScores:(id)sender;

- (IBAction)done;

@end
@protocol HighScoresViewControllerDelegate  // new 100821

-(void) highScoresViewControllerDidFinish: (HighScoresViewController *) controller;

@end
