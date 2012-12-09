

#import "HopShopAppDelegate.h"
#import "FormulaeViewController.h"
//#import "Brew.h"
//#import "HopShopConstants.h"
//#import "Formula.h"

@implementation HopShopAppDelegate

#define fm [NSFileManager defaultManager]

- (void) applicationWillTerminate:(NSNotification *)notification
{
	[[NSThread mainThread] performBlock:^{
//		[FormulaDescriptions saveNewEntriesToDisk];
	}waitUntilDone:YES];
}
//must Initialize the value transformers used throughout the application bindings
+ (void)initialize
{
	[NSVT setValueTransformer:AZInstallationStatusToImageTransformer.new forName:@"AZInstallationStatusToImageTransformer"];
}

+ (HopShopAppDelegate *)delegate
{
	return (HopShopAppDelegate*)NSApplication.sharedApplication.delegate;
}

- (NSS *)pathForAppData
{
//	NSS *folder = [@"~/Library/Application Support/HopShop/" stringByExpandingTildeInPath];
	NSS *folder = [NSB applicationSupportFolder];
	NSError *error;
	if (![fm fileExistsAtPath:folder])
		if (![fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error])
			[self showError:@"Can't create directory!"];
	return folder;
}

- (void)showError:(NSS *)errorMessage {}

#pragma mark - BrewDelegate methods

//- (void)outputReceived:(NSS *)output
//{
//	[AZNOTCENTER postNotificationName:NotificationOutputReceived object:output];
//}
//
//- (void)updateDidComplete:(NSS *)output
//{
//	self.updateItem.enabled = YES;
//	[AZNOTCENTER postNotificationName:NotificationUpdateCompleted object:output];
//}
//
#pragma mark - Toolbar Item handlers

//- (IBAction)brewUpdate:(id)sender
//{
//	[AZNOTCENTER postNotificationName:NotificationOutputReceived object:@"Updating . . ."];
//	self.updateItem.enabled = NO;
////	Brew *brew = [Brew.alloc initWithDelegate:self];
////	[brew update];
//}

@end
