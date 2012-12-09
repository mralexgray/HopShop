

//#import "Brew.h"

//@class OutputWindowViewController;
#import <AtoZ/AtoZ.h>

@interface HopShopAppDelegate : NSObject <NSApplicationDelegate>
//, BrewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSToolbarItem *updateItem;
@property (RONLY) NSS *pathForAppData;

+ (HopShopAppDelegate*) delegate;

- (IBAction)brewUpdate:(id)sender;
- (void)showError:(NSS *)errorMessage;

@end
