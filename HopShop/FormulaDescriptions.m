//
//  FormulaDescription.m
//  HopShop
//
//  Created by Alex Gray on 11/27/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "FormulaDescriptions.h"
#import "Formula.h"

@interface FormulaDescriptions ()
@property (strong, nonatomic) NSD *reference;
@property (strong, nonatomic) NSS  *savePath;
@property (strong, nonatomic) NSMD *entriesToAdd;
@property (weak) 			  NSOQ *q;
@end
@implementation FormulaDescriptions

- (void) setUp
{
	_q = AZSharedSingleOperationQueue();
	NSLog(@"setting up FormulaDescriptions singleton!");
	_entriesToAdd 	= NSMD.new;
	_savePath 		= [NSB.applicationSupportFolder withPath:@"updatedDescriptions.plist"];
	NSS *loadPath   	= [AZFILEMANAGER fileExistsAtPath:_savePath] ? _savePath : [[NSB mainBundle]pathForResource:@"descriptions" ofType:@"plist"];
	_reference 		= [NSD dictionaryWithContentsOfFile:loadPath];
	FormulaDescriptions.sharedInstance = self;
}

+ (NSS*) descriptionForName: (NSS*)name;
{
	return FormulaDescriptions.sharedInstance.reference[name] ?: nil;
}

+ (NSS*) descriptionForFormula:(Formula*)formula;
{
	return	[FormulaDescriptions.sharedInstance descriptionForFormula:formula];
}
- (NSS*) descriptionForFormula:(Formula*)formula
{
	NSS* desc = FormulaDescriptions.sharedInstance.reference[formula.name];
	/*if (!desc) {
		[_q addOperationWithBlock:^{
			NSString * google = googleSearchFor(formula.name) ?: nil;
			[NSTimer timerWithTimeInterval:2 block:^(NSTimeInterval time) {
				NSLog(@"throttling google query");
			} repeats:NO];
			if (google){
				NSLog(@"google search for: %@ found: %@",formula.name, google);
				FormulaDescriptions.sharedInstance.entriesToAdd[formula.name] = google;
				formula.desc = google;
				formula.googleGenerated = YES;
			} else NSLog(@"no description from google for: %@.  Queued operations:%ld", formula.name, _q.operationCount);

		}];
	}*/
	return desc ?: nil;// @"Pending";
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
