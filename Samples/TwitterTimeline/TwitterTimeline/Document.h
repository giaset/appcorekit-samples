//
//  Document.h
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>


@interface Tweet : CKObject
@property(nonatomic,copy) NSURL* imageUrl;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* message;
@property(nonatomic,copy) NSString* identifier;
@end

@interface Timeline : CKObject
@property(nonatomic) CKArrayCollection* tweets;
@end