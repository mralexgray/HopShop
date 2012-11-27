

#import "HopShopAppDelegateTests.h"
#import "HopShopAppDelegate.h"

@implementation HopShopAppDelegateTests

- (void)testAppDelegateShouldNotBeNil
{
	HopShopAppDelegate *delegate = [HopShopAppDelegate delegate];
	STAssertNotNil(delegate, @"Delegate should not be nil");
}

- (void)testApplicationDataPathShouldBeCorrect
{
	NSS *path = [[HopShopAppDelegate delegate] pathForAppData];
	NSS *pathCorrect = [@"~/Library/Application Support/HopShop/" stringByExpandingTildeInPath];
	STAssertEqualObjects(pathCorrect, path, [NSString stringWithFormat:@"Application Data Path should be %@ but was %@", pathCorrect, path]);
}

- (void)testApplicationDataPathShouldExist
{
	NSS *path = [[HopShopAppDelegate delegate] pathForAppData];
	STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path], [NSString stringWithFormat:@"Path %@ should exist", path]);
}

@end
