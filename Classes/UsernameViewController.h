//
//  UsernameViewController.h
//  wl2
//
//  Created by Harry Layman on 12/23/10.
//  Copyright 2010 NewportCoastSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UsernameViewControllerDelegate;


@interface UsernameViewController : UIViewController {
	id <UsernameViewControllerDelegate> delegate;
	
	NSString  *wlUserName;
	IBOutlet  UITextField   *theUserNameField;

}

- (IBAction) done;
@property (nonatomic, assign) id <UsernameViewControllerDelegate> delegate;
@property (nonatomic, assign) NSString* wlUserName;

@end

@protocol UsernameViewControllerDelegate 
- (void) usernameViewControllerDidFinish:(UsernameViewController *)controller;

@end
