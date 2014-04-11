//
//  AppDelegate.m
//  BookmarkTest
//
//  Created by uasi on 4/11/14.
//  Copyright (c) 2014 exsen.org. All rights reserved.
//

#import "AppDelegate.h"

#import "NSBundle+OBCodeSigningInfo.h"

@interface AppDelegate ()

@property (nonatomic) IBOutlet NSTextField *filePathURLField;
@property (nonatomic) IBOutlet NSTextField *fileReferenceURLField;
@property (nonatomic) IBOutlet NSTextField *bookmarkErrorField;
@property (nonatomic) NSData *bookmark;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

- (IBAction)openFile:(id)sender
{
  NSOpenPanel *panel = [NSOpenPanel openPanel];
  if ([panel runModal] == NSFileHandlingPanelOKButton) {
    NSURLBookmarkCreationOptions options = [[NSBundle mainBundle] ob_isSandboxed] ? NSURLBookmarkCreationWithSecurityScope : 0;
    NSError *error;
    self.bookmark = [panel.URL bookmarkDataWithOptions:options includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
    if (!self.bookmark) {
      self.bookmarkErrorField.stringValue = error.description;
    }
    [self showResolvedURL:self];
  }
}

- (IBAction)showResolvedURL:(id)sender
{
  if (!self.bookmark) {
    self.filePathURLField.stringValue = self.fileReferenceURLField.stringValue = @"(No bookmark set)";
    return;
  }
  NSURLBookmarkResolutionOptions options = [[NSBundle mainBundle] ob_isSandboxed] ? NSURLBookmarkResolutionWithSecurityScope : 0;
  BOOL isStale;
  NSError *error;
  NSURL *URL = [NSURL URLByResolvingBookmarkData:self.bookmark options:options relativeToURL:nil bookmarkDataIsStale:&isStale error:&error];
  if (!URL) {
    self.bookmarkErrorField.stringValue = error.description;
    self.filePathURLField.stringValue = self.fileReferenceURLField.stringValue = @"(No resolved URL)";
    return;
  }
  self.filePathURLField.stringValue = [NSString stringWithFormat:@"%@%@", isStale ? @"(stale) " : @"", [URL absoluteString]];
  self.fileReferenceURLField.stringValue = [[URL fileReferenceURL] absoluteString];
}

@end
