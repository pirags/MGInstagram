//
//  MGInstagram.m
//  MGInstagramDemo
//
//  Created by Mark Glagola on 10/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGInstagram.h"

@interface MGInstagram () {
    UIDocumentInteractionController *documentInteractionController;
}

@property (nonatomic, strong) NSString *photoDirectory;
@property (nonatomic, strong) NSString *photoFileName;

+ (instancetype)sharedInstance;

@end

@implementation MGInstagram

NSString* const kInstagramAppURLString = @"instagram://app";
NSString* const kInstagramOnlyPhotoFileName = @"tempinstgramphoto.igo";

#pragma mark - Init

+ (instancetype) sharedInstance
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
        self.photoDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        self.photoFileName = kInstagramOnlyPhotoFileName;
    }
    
    return self;
}

#pragma mark - Public

+ (void) setPhotoDirectory:(NSString *)directory {
    [MGInstagram sharedInstance].photoDirectory = directory;
}

+ (NSString*) photoFilePath {
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:[MGInstagram sharedInstance].photoDirectory],[MGInstagram sharedInstance].photoFileName];
}

+ (void) setPhotoFileName:(NSString*)fileName {
    [MGInstagram sharedInstance].photoFileName = fileName;
}

+ (NSString*) photoFileName {
    return [MGInstagram sharedInstance].photoFileName;
}

+ (BOOL) isAppInstalled {
    NSURL *appURL = [NSURL URLWithString:kInstagramAppURLString];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

+ (BOOL) isImageCorrectSize:(UIImage*)image {
    CGImageRef cgImage = [image CGImage];
    return (CGImageGetWidth(cgImage) >= 612 && CGImageGetHeight(cgImage) >= 612);
}

+ (void) postImage:(UIImage*)image inView:(UIView*)view {
    [self postImage:image withCaption:nil inView:view];
}

+ (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view {
    [self postImage:image withCaption:caption inView:view delegate:nil];
}

+ (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view delegate:(id<UIDocumentInteractionControllerDelegate>)delegate {
    [[MGInstagram sharedInstance] postImage:image withCaption:caption inView:view delegate:delegate];
}

#pragma mark - Private

- (void) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view delegate:(id<UIDocumentInteractionControllerDelegate>)delegate {
    
    if (!image) {
        [NSException raise:NSInternalInconsistencyException format:@"Image cannot be nil!"];
    }
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[MGInstagram photoFilePath] atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[MGInstagram photoFilePath]];
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    documentInteractionController.UTI = @"com.instagram.exclusivegram";
    documentInteractionController.delegate = delegate;
    if (caption) {
        documentInteractionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
    }
    [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
}

@end
