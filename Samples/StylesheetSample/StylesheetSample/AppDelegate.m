//
//  AppDelegate.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "CKStylesheetSampleViewController.h"



@implementation AppDelegate

- (id)init{
   self = [super init];
   [[CKStyleManager defaultManager]loadContentOfFileNamed:@"Stylesheet"];
   [CKMappingContext loadContentOfFileNamed:@"Api"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
#ifdef __has_feature(objc_arc)
    [[CKConfiguration sharedInstance]setUsingARC:YES];
#endif

   return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [CKStylesheetSampleViewController controller];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
