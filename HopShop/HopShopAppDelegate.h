

#import "Brew.h"

@class OutputWindowViewController;

@interface HopShopAppDelegate : NSObject <NSApplicationDelegate, BrewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSToolbarItem *updateItem;


+ (HopShopAppDelegate*) delegate;

- (IBAction)brewUpdate:(id)sender;
- (void)showError:(NSS *)errorMessage;
- (NSS *)pathForAppData;

@end
