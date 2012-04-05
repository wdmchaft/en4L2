//
//  Wordz1_2AppDelegate.h
//  Wordz1.2
//
//  Created by Newport Coast Software / Harry A. Layman of 7/31/10
//  Copyright Newport Coast Software (C) 2010. All rights reserved.
//        

#import <UIKit/UIKit.h>

@class Wordz1_2ViewController;

@interface Wordz1_2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Wordz1_2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Wordz1_2ViewController *viewController;

@end

