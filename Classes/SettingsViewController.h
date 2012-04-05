//
//  SettingsViewController.h
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//     

#import <UIKit/UIKit.h>
@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UIViewController {
id<SettingsViewControllerDelegate> delegate;

/*	
	
	IBOutlet UITextField *textMatchMode;
	IBOutlet UITextField *textPictureLang;	
 */
	NSString *mmSetting;
	NSString *plSetting;
//	NSString *theUseAlphaSetting;
    
    IBOutlet UISwitch *flipSwitch;    
    IBOutlet UISwitch *allowEMSwitch; 
	
	int sidxSetting;
	int useAlphaSetting;
	int preventEMSetting;    
	
	IBOutlet UITextField *theMMTextField;
	IBOutlet UITextField *thePLTextField; 
	IBOutlet UITextField *theSIDXTextfield;
	
}

-(IBAction) changeFlipSwitch: (id) sender;

-(IBAction) changeAEMSwitch: (id) sender;

-(IBAction)done;

@property (nonatomic, assign) id 
		<SettingsViewControllerDelegate> delegate;
@property (nonatomic, assign) NSString* mmSetting;
@property (nonatomic, assign) NSString* plSetting;

@property (nonatomic, assign) int sidxSetting;
@property (nonatomic, assign) int useAlphaSetting;
@property (nonatomic, assign) int preventEMSetting;


@end

@protocol SettingsViewControllerDelegate

-(void) settingsViewControllerDidFinish: (SettingsViewController *) controller;

@end
