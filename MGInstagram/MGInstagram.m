//
//  MGInstagram.m
//  MGInstagramDemo
//
//  Created by Mark Glagola on 10/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGInstagram.h"

@interface MGInstagram ()
{
    UIDocumentInteractionController *documentInteractionController;
}

@property (nonatomic, strong) NSString *photoDirectory;

+ (MGInstagram *)sharedInstance;

@end

@implementation MGInstagram

NSString* const kInstagramAppURLString = @"instagram://app";
NSString* const kInstagramPhotoFileName = @"tempinstgramphoto.igo";

#pragma mark - Init

+ (MGInstagram *)sharedInstance
{
    static MGInstagram* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MGInstagram new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    }

    return self;
}

#pragma mark - Public

+ (BOOL) isAppInstalled {
    NSURL *appURL = [NSURL URLWithString:kInstagramAppURLString];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

+ (BOOL) isImageCorrectSize:(UIImage*)image {
    CGImageRef cgImage = [image CGImage];
    return (CGImageGetWidth(cgImage) >= 612 && CGImageGetHeight(cgImage) >= 612);
}

+ (void) setPhotoDirectory:(NSString *)directory {
    [MGInstagram sharedInstance].photoDirectory = directory;
}

+ (void) postImage:(UIImage*)image inView:(UIView*)view {
    [[MGInstagram sharedInstance] postImage:image withCaption:nil inView:view];
}
+ (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view {
    [[MGInstagram sharedInstance] postImage:image withCaption:caption inView:view];
}

#pragma mark - Private

- (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view
{
    if (!image)
        [NSException raise:NSInternalInconsistencyException format:@"Image cannot be nil!"];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[self photoFilePath] atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[self photoFilePath]];
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    documentInteractionController.UTI = @"com.instagram.exclusivegram";
    documentInteractionController.delegate = self;
    if (caption)
        documentInteractionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
    [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
}

- (NSString*) photoFilePath {
    return [NSString stringWithFormat:@"%@/%@",self.photoDirectory,kInstagramPhotoFileName];
}

@end
