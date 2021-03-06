//
//  MGInstagram.h
//  MGInstagramDemo
//
//  Created by Mark Glagola on 10/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGInstagram : NSObject <UIDocumentInteractionControllerDelegate>

extern NSString* const kInstagramAppURLString;
extern NSString* const kInstagramOnlyPhotoFileName;

//DEFAULT file name is kInstagramDefualtPhotoFileName
//DEFAULT file name is restricted to only the instagram app
//Make sure your photoFileName has a valid photo extension.
+ (void) setPhotoFileName:(NSString*)fileName;
+ (NSString*) photoFileName;

//checks to see if user has instagram installed on device
+ (BOOL) isAppInstalled;

//checks to see if image is large enough to be posted by instagram, instagram policy is not to stretch or scale up smaller images
//returns NO if image dimensions are under 612x612
+ (BOOL) isImageCorrectSize:(UIImage*)image;

// Sets the directory where the temp file is stored.
+ (void) setPhotoDirectory:(NSString *)directory;
+ (NSString*) photoFilePath;

//post image to instagram by passing in the target image and
//the view in which the user will be presented with the instagram model
+ (void) postImage:(UIImage*)image inView:(UIView*)view;
//Same as above method but with the option for a photo caption
+ (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view;
+ (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view delegate:(id<UIDocumentInteractionControllerDelegate>)delegate;

@end
