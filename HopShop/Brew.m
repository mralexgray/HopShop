

#import "Brew.h"

@interface Brew (private)
- (void)runTask:(BrewOperation)operation arguments:(NSA*)arguments;
@end

@implementation Brew
@synthesize isRunning, currentOperation, currentOutput;

static NSDictionary *operations;

+ (void)initialize
{
	operations = @{	@(BrewOperationNone): 		@"",
					@(BrewOperationList): 		@"list",
					@(BrewOperationSearch): 	@"search",
					@(BrewOperationInstall): 	@"install",
					@(BrewOperationUninstall): 	@"uninstall",
					@(BrewOperationUpdate): 	@"update",
					@(BrewOperationUpgrade): 	@"upgrade",
					@(BrewOperationInfo): 		@"info",
					@(BrewOperationOutdated):	@"outdated",
					@(BrewOperationDesc):		@"desc"};
}

- (id)initWithDelegate:(id<BrewDelegate>)delegate
{
	if (!(self = [super init])) return nil;
	self.delegate = delegate;
	return self;
}

#pragma mark - Brew operations

- (void)search:(NSS*)srchStr	 	 {	[self runTask:BrewOperationSearch    arguments: @[ srchStr ?: @""]];  }

- (void)list:(NSA*)formulae		 {	[self runTask:BrewOperationList 	 arguments:formulae];	}

- (void)install:(NSA*)formulae	 {	[self runTask:BrewOperationInstall 	 arguments:formulae];	}

- (void)uninstall:(NSA*)formulae {	[self runTask:BrewOperationUninstall arguments:formulae];	}

- (void)update					 {	[self runTask:BrewOperationUpdate 	 arguments:     nil];	}

- (void)upgrade:(NSA*)formulae 	 {	[self runTask:BrewOperationUpgrade 	 arguments:formulae];	}

- (void)info:(NSA*)formulae		 {	[self runTask:BrewOperationInfo 	 arguments:formulae];	}

- (void)outdated				 {	[self runTask:BrewOperationOutdated  arguments:     nil];	}

- (void)desc:(NSS*)srchStr	 	 {	[self runTask:BrewOperationDesc    arguments: @[ @"-s", srchStr ?: @""] appendPath:[[NSB mainBundle]resourcePath]];  }

#pragma mark - Helper methods


- (void)runTask:(BrewOperation)operation arguments:(NSA*)arguments
{
	[self runTask:operation arguments:arguments appendPath:nil];
}

- (void)runTask:(BrewOperation)operation arguments:(NSA*)arguments appendPath:(NSS*)newPath
{
	isRunning ? ^{
		[self.brewTask stopProcess];
		self.brewTask = nil;
		currentOperation = BrewOperationNone;
	}() : ^{
		currentOperation = operation;
		NSArray *cmdLine = [self buildCommandLine:operation arguments:(NSA*)arguments];
//		NSLog(@"sending cmd: %@", cmdLine);
		self.brewTask = [[TaskWrapper alloc] initWithController:self arguments:cmdLine appendPath:newPath];
		[self.brewTask startProcess];
	}();
}

- (NSA*)buildCommandLine:(BrewOperation)operation arguments:(NSA*)arguments
{
	NSMutableArray *cmdLine = [NSMutableArray arrayWithObject:@"/usr/local/bin/brew"];
	NSS *command = operations[@(operation)];
	command != nil && command.length > 0 ? [cmdLine addObject:command] : nil;
	[cmdLine addObjectsFromArray:arguments];
	return cmdLine.copy;
}

#pragma mark - TaskWrapperController methods

- (void)appendOutput:(NSS *)output
{
	if (currentOperation == BrewOperationUpdate)
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(outputReceived:)])
			[self.delegate outputReceived:output];
	currentOutput = [currentOutput stringByAppendingString:output];
}

- (void)processStarted {	currentOutput = @""; }

- (void)processFinished
{
	NSA* array = [[currentOutput componentsSeparatedByString:@"\n"]arrayByRemovingLastObject];
//	[array removeLastObject];
	switch (currentOperation) {
		case BrewOperationList:
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(listDidComplete:)])
				[self.delegate listDidComplete:array];
			break;
		case BrewOperationSearch:
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchDidComplete:)])
				[self.delegate searchDidComplete:array];
			break;
		case BrewOperationInfo:
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infoDidComplete:)])
				[self.delegate infoDidComplete:currentOutput];
			break;
		case BrewOperationUpdate:
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateDidComplete:)])
				[self.delegate updateDidComplete:currentOutput];
			break;
		case BrewOperationDesc:
			NSLog(@"output:%@  class: %@", currentOutput, array)
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(descDidComplete:)])
				[self.delegate descDidComplete:[[currentOutput componentsSeparatedByString: @"\n"] objectAtIndex:0]];
			break;
		default:
			break;
	}
}

@end
