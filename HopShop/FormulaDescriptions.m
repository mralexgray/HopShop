//
//  FormulaDescription.m
//  HopShop
//
//  Created by Alex Gray on 11/27/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "FormulaDescriptions.h"

static NSMA *noResults = nil;

@interface FormulaDescriptions ()
@property (strong, nonatomic) NSD *reference;
@property (strong, nonatomic) NSS  *savePath;
@property (strong, nonatomic) NSMD *entriesToAdd;
@end
@implementation FormulaDescriptions

- (void) setUp
{
	NSLog(@"setting up FormulaDescriptions singleton!");
	noResults 		= [NSMA array];
	self.entriesToAdd = [NSMD dictionary];
	self.savePath 	= [[NSB applicationSupportFolder]withPath:@"updatedDescriptions.plist"];
	NSS *loadPath   = [AZFILEMANAGER fileExistsAtPath:_savePath] ? _savePath : [[NSB mainBundle]pathForResource:@"descriptions" ofType:@"plist"];
	self.reference 	= [NSD objectWithContentsOfFile:loadPath];
}

+ (NSS*) descriptionForName: (NSS*)name;
{
	NSS* result = [FormulaDescriptions.sharedInstance.reference objectForKey:name];
	if (!result) [noResults addObject:name];
	return result;
}

+ (NSS*) googleSearchFor:(NSS*)name
{
	NSString * google = googleSearchFor(name) ?: nil;
	if (google){
		NSLog(@"google search for: %@ found: %@",name, google);
			FormulaDescriptions.sharedInstance.entriesToAdd[name] = google;
			return google;
	}
	return google;
}

+ (void) saveNewEntriesToDisk
{
	NSD *oldD = FormulaDescriptions.sharedInstance.reference.copy;
	NSD *newD = [oldD dictionaryByAppendingEntriesFromDictionary:FormulaDescriptions.sharedInstance.entriesToAdd];
	BOOL success = [newD writeToFile:FormulaDescriptions.sharedInstance.savePath atomically:NO];
	NSLog(@"saved newdictionary to plist: %@ with:%ld entries (was: %ld", StringFromBOOL(success), newD.allKeys.count, oldD.allKeys.count);
}

@end
