//
//  DemoViewController.h
//  en4L2
//
//  Created by Harry Layman on 9/21/11.
//  Copyright 2011 NewportCoastSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol DemoViewControllerDelegate;

@interface DemoViewController : UIViewController {
    id <DemoViewControllerDelegate> delegate;
    
    MPMoviePlayerController *player;  // add movie    
    
    IBOutlet UIButton *doneButton;
    
}

-(IBAction) done;


@property (nonatomic, assign) id <DemoViewControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIButton *doneButton;

@end

@protocol DemoViewControllerDelegate
- (void) demoViewControllerDidFinish:(DemoViewController *) controller;
@end