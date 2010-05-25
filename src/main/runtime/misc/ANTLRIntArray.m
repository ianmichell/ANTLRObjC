//
//  ANTLRIntArray.m
//  ANTLR
//
//  Created by Ian Michell on 27/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRIntArray.h"


@implementation ANTLRIntArray

@synthesize data;

-(id) init
{
	self = [super init];
	if (self)
	{
		pool = [NSAutoreleasePool new];
		p = -1;
		buffer = [[[NSMutableData alloc] initWithCapacity:ANTLR_INT_ARRAY_INITIAL_SIZE] autorelease];
		data = [buffer mutableBytes];
	}
	return self;
}

-(void) dealloc
{
	data = nil;
	[pool drain];
	[super dealloc];
}

-(void) add:(NSInteger) v
{
	[self ensureCapacity:p + 1];
	data[++p] = v;
}

-(void) push:(NSInteger) v
{
	[self add:v];
}

-(NSInteger) pop
{
	NSInteger v = data[p];
	p--;
	return v;
}

-(NSInteger) get:(NSInteger) i
{
	return data[i];
}

// FIXME: Java runtime returns p, I'm not so sure it's right so have added p + 1 to show true size!
-(NSInteger) size
{
	return p + 1;
}

-(void) clear
{
	p = -1;
}

-(void) ensureCapacity:(NSInteger) index
{
	if ((index + 1) >= [buffer length])
	{
		NSInteger newSize = [buffer length] * 2;
		if (index > newSize)
		{
			newSize = index + 1;
		}
		[buffer setLength:newSize];
	}
}

@end

