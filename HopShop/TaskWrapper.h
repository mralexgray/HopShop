/*	File:			TaskWrapper.h
	Description:	 This class is a generalized process handling class that makes asynchronous interaction with an NSTask easier.	There is also a protocol designed to work in conjunction with the TaskWrapper class; your process controller should conform to this protocol.	TaskWrapper objects are one-shot (since NSTask is one-shot); if you need to run a task more than once, destroy/create new TaskWrapper objects.
 	Author:				EP & MCF
 	Copyright:		 © Copyright 2002 Apple Computer, Inc. All rights reserved.	*/

@protocol TaskWrapperController
// Your controller's implementation of this method will be called when output arrives from the NSTask.
// Output will come from both stdout and stderr, per the TaskWrapper implementation.
- (void)appendOutput:(NSS *)output;
// This method is a callback which your controller can use to do other initialization when a process is launched.
- (void)processStarted;
// This method is a callback which your controller can use to do other cleanup when a proces is halted.
- (void)processFinished;
@end

@interface TaskWrapper : NSObject
{
		NSTask						*task;
		id <TaskWrapperController>	controller;
		NSArray						*arguments;
		NSS 						*pathAddition;
}
// This is the designated initializer - pass in your controller and any task arguments.
// The first argument should be the path to the executable to launch with the NSTask.
- (id)initWithController:(id <TaskWrapperController>)controller arguments:(NSA*)args;
- (id)initWithController:(id <TaskWrapperController>)controller arguments:(NSA*)args appendPath:(NSS*)pathEnv;
// This method launches the process, setting up asynchronous feedback notifications.
- (void) startProcess;
// This method stops the process, stoping asynchronous feedback notifications.
- (void) stopProcess;
@end