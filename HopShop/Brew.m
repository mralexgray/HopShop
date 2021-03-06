

#import "Brew.h"

@interface Brew (private)
- (void)runTask:(BrewOperationType)operation arguments:(NSA*)arguments;
- (NSA*)buildCommandLine:(BrewOperationType)operation arguments:(NSA*)arguments;
@end

@implementation Brew
@synthesize isRunning, currentOperation, currentOutput;

//static NSDictionary *operations;
//
//+ (void)initialize
//{
//	operations = @{	@(BrewOperationNone)	  : @"",
//					@(BrewOperationList)	  : @"list",
//					@(BrewOperationSearch)	  : @"search",
//					@(BrewOperationInstall)	  : @"install",
//					@(BrewOperationUninstall) : @"uninstall",
//					@(BrewOperationUpdate)    : @"update",
//					@(BrewOperationUpgrade)   : @"upgrade",
//					@(BrewOperationInfo)      : @"info",
//					@(BrewOperationOutdated)  :	@"outdated",
//					@(BrewOperationDesc)      :	@"desc"};
//}

- (id) initWithDelegate: (id<BrewDelegate>)delegate searchFor:(NSS*)string;
{
	if (self != super.init ) return nil;
	self.delegate = delegate;
	self.operation = BrewOperationSearch;
	self.searchString = string;
	return self;
}


- (id) initWithDelegate: (id<BrewDelegate>)delegate operation:(BrewOperationType)type;
{
	if (self != super.init ) return nil;
	self.delegate = delegate;
	self.operation = type;
	return self;
}
- (id) initWithFormula:  (Formula*)formula 			operation:(BrewOperationType)type;
{
	if (self != super.init ) return nil;
	self.formula = formula;
	self.operation = type;
	return self;
}
- (void) main {

	self.operation == BrewOperationSearch	?
		[self runTask:BrewOperationSearch arguments: @[ self.searchString ?: @""]] :
	self.operation == BrewOperationList		?
	 [self runTask:BrewOperationList 	   arguments:formulae];	}

	- (void) install:   (NSA*)formulae	{ [self runTask:BrewOperationInstall   arguments:formulae];	}

	- (void) uninstall: (NSA*)formulae 	{ [self runTask:BrewOperationUninstall arguments:formulae];	}

	- (void) update					 	{ [self runTask:BrewOperationUpdate    arguments:     nil];	}

	- (void) upgrade:   (NSA*)formulae 	{ [self runTask:BrewOperationUpgrade   arguments:formulae];	}

	- (void) info:      (NSA*)formulae  { [self runTask:BrewOperationInfo 	   arguments:formulae];	}

	- (void) outdated				 	{ [self runTask:BrewOperationOutdated  arguments:     nil];	}

	- (void) desc:      (NSS*)srchStr	{ [self runTask:BrewOperationDesc      arguments: @[ @"-s", srchStr ?: @""] appendPath:[[NSB mainBundle]resourcePath]];  }




//	- (void) list:      (NSA*)formulae	{ [self runTask:BrewOperationList 	   arguments:formulae];	}
//
//	- (void) install:   (NSA*)formulae	{ [self runTask:BrewOperationInstall   arguments:formulae];	}
//
//	- (void) uninstall: (NSA*)formulae 	{ [self runTask:BrewOperationUninstall arguments:formulae];	}
//
//	- (void) update					 	{ [self runTask:BrewOperationUpdate    arguments:     nil];	}
//
//	- (void) upgrade:   (NSA*)formulae 	{ [self runTask:BrewOperationUpgrade   arguments:formulae];	}
//
//	- (void) info:      (NSA*)formulae  { [self runTask:BrewOperationInfo 	   arguments:formulae];	}
//
//	- (void) outdated				 	{ [self runTask:BrewOperationOutdated  arguments:     nil];	}
//
//	- (void) desc:      (NSS*)srchStr	{ [self runTask:BrewOperationDesc      arguments: @[ @"-s", srchStr ?: @""] appendPath:[[NSB mainBundle]resourcePath]];  }



#pragma mark - Brew operations

//- (void) search:    (NSS*)srchStr	{ [self runTask:BrewOperationSearch    arguments: @[ srchStr ?: @""]];  }
//
//- (void) list:      (NSA*)formulae	{ [self runTask:BrewOperationList 	   arguments:formulae];	}
//
//- (void) install:   (NSA*)formulae	{ [self runTask:BrewOperationInstall   arguments:formulae];	}
//
//- (void) uninstall: (NSA*)formulae 	{ [self runTask:BrewOperationUninstall arguments:formulae];	}
//
//- (void) update					 	{ [self runTask:BrewOperationUpdate    arguments:     nil];	}
//
//- (void) upgrade:   (NSA*)formulae 	{ [self runTask:BrewOperationUpgrade   arguments:formulae];	}
//
//- (void) info:      (NSA*)formulae  { [self runTask:BrewOperationInfo 	   arguments:formulae];	}
//
//- (void) outdated				 	{ [self runTask:BrewOperationOutdated  arguments:     nil];	}
//
//- (void) desc:      (NSS*)srchStr	{ [self runTask:BrewOperationDesc      arguments: @[ @"-s", srchStr ?: @""] appendPath:[[NSB mainBundle]resourcePath]];  }

#pragma mark - Helper methods


- (void)runTask:(BrewOperationtype)operation arguments:(NSA*)arguments
{
	[self runTask:operation arguments:arguments appendPath:nil];
}

- (void)runTask:(BrewOperationtype)operation arguments:(NSA*)arguments appendPath:(NSS*)newPath
{
	isRunning ? ^{
		[self.brewTask stopProcess];
		self.brewTask = nil;
//		currentOperation = BrewOperationNone;
	}() : ^{
//		currentOperation = operation;
		NSArray *cmdLine = [self buildCommandLine:_operation arguments:arguments];
		NSLog(@"sending cmd: %@", cmdLine);
		self.brewTask 	 = [TaskWrapper.alloc initWithController:self arguments:cmdLine appendPath:newPath];
		[self.brewTask startProcess];
	}();
}

- (NSA*)buildCommandLine:(BrewOperationType)operation arguments:(NSA*)arguments
{
	NSMA *cmdLine = [NSMA arrayWithObject:@"/usr/local/bin/brew"];
	NSS *command = operations[@(operation)];
	command != nil && command.length > 0 ? [cmdLine addObject:command] : nil;
	[cmdLine addObjectsFromArray:arguments];
	return cmdLine.copy;
}

#pragma mark - TaskWrapperController methods
- (void)appendOutput:(NSS*)output
{
	if (currentOperation == BrewOperationUpdate)
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(outputReceived:)])
			[self.delegate outputReceived:output];
	currentOutput = [currentOutput stringByAppendingString:output];
}

- (void)processStarted { currentOutput = @""; }

- (void)processFinished
{
	NSA* array = [[currentOutput componentsSeparatedByString:@"\n"]arrayByRemovingLastObject];

	currentOperation == BrewOperationList ?
			 self.delegate != nil && [self.delegate respondsToSelector:@selector(listDidComplete:)] ?
				[self.delegate listDidComplete:array] : nil :
	currentOperation == BrewOperationSearch ?
			self.delegate && [self.delegate respondsToSelector:@selector(searchDidComplete:)] ?
				[self.delegate searchDidComplete:array] : nil :
	currentOperation == BrewOperationInfo ?
			self.delegate && [self.delegate respondsToSelector:@selector(infoDidComplete:)] ?
				[self.delegate infoDidComplete:currentOutput] : nil :
	currentOperation == BrewOperationUpdate ?
			self.delegate && [self.delegate respondsToSelector:@selector(updateDidComplete:)] ?
				[self.delegate updateDidComplete:currentOutput] : nil :
	currentOperation == BrewOperationDesc ? ^{
			NSLog(@"output:%@  class: %@", currentOutput, array)
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(descDidComplete:)])
				[self.delegate descDidComplete:[[currentOutput componentsSeparatedByString: @"\n"] objectAtIndex:0]];
	}() : nil;
}

@end
