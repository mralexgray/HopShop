//
//  BrewOperation.h
//  HopShop
//
//  Created by Alex Gray on 12/3/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

typedef NS_ENUM(NSUI, BrewOperationType) {
	BrewOperationNone = 0,
	BrewOperationList,
	BrewOperationSearch,
	BrewOperationInfo,
	BrewOperationUpdate,
	BrewOperationUpgrade,
	BrewOperationInstall,
	BrewOperationUninstall,
	BrewOperationOutdated,
	BrewOperationDesc
};

@class Formula, TaskWrapper;
@interface BrewOperation : NSOperation

@property (NATOM) BOOL 			 isRunning;
@property (STRNG) NSS 			*currentOutput;
@property (STRNG) TaskWrapper 	*brewTask;


- (id)   initWithDelegate:(id<BrewDelegate>)delegate;

- (void) desc:		(NSS*)searchString;
- (void) search:	(NSS*)searchString;
- (void) list:		(NSA*)formulae;
- (void) install:	(NSA*)formulae;
- (void) uninstall:	(NSA*)formulae;
- (void) upgrade:	(NSA*)formulae;
- (void) info:		(NSA*)formulae;
- (void) update;
- (void) outdated;

- (NSA*)buildCommandLine:(BrewOperation)operation arguments:(NSA*)arguments;

@end

@end
