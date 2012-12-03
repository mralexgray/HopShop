//
//  FormulaDescription.m
//  HopShop
//
//  Created by Alex Gray on 11/27/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "FormulaDescriptions.h"



@interface FormulaDescriptions ()
@property (strong, nonatomic) NSD *reference;
@property (strong, nonatomic) NSS  *savePath;
@property (strong, nonatomic) NSMD *entriesToAdd;
@end
@implementation FormulaDescriptions

- (void) setUp
{
	NSLog(@"setting up FormulaDescriptions singleton!");
	self.entriesToAdd 	= [NSMD dictionary];
	self.savePath 		= [[NSB applicationSupportFolder]withPath:@"updatedDescriptions.plist"];
	NSS *loadPath   	= [AZFILEMANAGER fileExistsAtPath:_savePath] ? _savePath : [[NSB mainBundle]pathForResource:@"descriptions" ofType:@"plist"];
	self.reference 		= [NSD dictionaryWithContentsOfFile:loadPath];
	[FormulaDescriptions setSharedInstance:self];
}

+ (NSS*) descriptionForName: (NSS*)name;
{
	return [FormulaDescriptions.sharedInstance.reference objectForKey:name] ?: nil;
}

+ (NSS*) googleSearchFor:(NSS*)name
{
	NSString * google = googleSearchFor(name) ?: nil;
	if (google){
		NSLog(@"google search for: %@ found: %@",name, google);
			FormulaDescriptions.sharedInstance.entriesToAdd[name] = google;
			return google;
	}
	return google ?: nil;
}

+ (void) saveNewEntriesToDisk
{
	NSD *oldD = FormulaDescriptions.sharedInstance.reference;
	NSD *newD = [oldD dictionaryByAddingEntriesFromDictionary:FormulaDescriptions.sharedInstance.entriesToAdd];
	BOOL success = [newD writeToFile:FormulaDescriptions.sharedInstance.savePath atomically:YES];
	NSLog(@"saved newdictionary to plist: %@ with:%ld entries (was: %ld", StringFromBOOL(success), newD.allKeys.count, oldD.allKeys.count);
}

@end
