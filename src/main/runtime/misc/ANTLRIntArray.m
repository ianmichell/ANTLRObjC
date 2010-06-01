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
		data = [[NSMutableArray arrayWithCapacity:ANTLR_INT_ARRAY_INITIAL_SIZE] autorelease];
	}
	return self;
}

-(void) dealloc
{
	[pool drain];
	[super dealloc];
}

-(void) add:(NSInteger) v
{
	[data insertObject:[[NSNumber numberWithInt:v] autorelease] atIndex:++p];
}

-(void) push:(NSInteger) v
{
	[self add:v];
}

-(NSInteger) pop
{
	NSInteger v = [self get:p];
	p--;
	return v;
}

-(NSInteger) get:(NSInteger) i
{
	return [[data objectAtIndex:i] intValue];
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


@end

