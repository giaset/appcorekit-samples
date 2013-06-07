//
//  AppDelegate.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleTwitterTimelineModel.h"
#import "CKSampleTwitterDataSources.h"
#import "CKSampleTwitterTimelineViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (id)init{
    self = [super init];
    [[CKStyleManager defaultManager]loadContentOfFileNamed:@"Stylesheet"];
    [CKMappingContext loadContentOfFileNamed:@"CKSampleTwitterDataSources"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
    [[CKConfiguration sharedInstance]setUsingARC:YES];
    
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CKSampleTwitterTimelineModel* timeline = [CKSampleTwitterTimelineModel sharedInstance];
    timeline.tweets.feedSource = [CKSampleTwitterDataSources feedSourceForTweets];
    
    CKSampleTwitterTimelineViewController* viewController = [[CKSampleTwitterTimelineViewController alloc] initWithTimeline:timeline];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
