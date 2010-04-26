//
//  ANTLRLookaheadStream.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRLookaheadStream.h"
#import "ANTLRError.h"

@implementation ANTLRLookaheadStream

-(id) init
{
	self = [super init];
	if (self)
	{
		eofElementIndex = UNITIALIZED_EOF_ELEMENT_INDEX;
		markDepth = 0;
	}
	return self;
}

-(id) initWithEOF:(id) o
{
	self = [self init];
	if (self)
	{
		self.eof = o;
	}
	return self;
}

-(void) reset
{
	eofElementIndex = UNITIALIZED_EOF_ELEMENT_INDEX;
	[super reset];
}

-(id) nextElement
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void) consume
{
	[self sync:1];
	[self remove];
}

-(void) sync:(NSInteger) need
{
	NSInteger n = (p + need - 1) - [data count] + 1;
	if (n > 0)
	{
		[self fill:n];
	}
}

-(void) fill:(NSInteger) n
{
	for (NSInteger i = 0; i <= n; i++)
	{
		id o = [self nextElement];
		if (o == self.eof)
		{
			[data addObject:self.eof];
			eofElementIndex = [data count] - 1;
		}
		else
		{
			[data addObject:o];
		}
	}
}

-(NSInteger) size
{
	@throw [NSException exceptionWithName:ANTLRUnsupportedOperationException reason:@"Streams have no defined size" userInfo:nil];
}

-(id) LT:(NSInteger) i
{
	if (i == 0)
	{
		return nil;
	}
	if (i < 0)
	{
		return [self LB:-i];
	}
	if ((p + i - 1) >= eofElementIndex)
	{
		return self.eof;
	}
	[self sync:i];
	return [self get:(i - 1)];
}

-(id) LB:(NSInteger) i
{
	if (i == 0)
	{
		return nil;
	}
	if ((p - i) < 0)
	{
		return nil;
	}
	return [self get:-i];
}

-(id) currentSymbol
{
	return [self LT:1];
}

-(NSInteger) index
{
	return p;
}

-(NSInteger) mark
{
	markDepth++;
	lastMarker = [self index];
	return lastMarker;
}

-(void) releaseWithMarker:(NSInteger) marker
{
	// no resources to release
}

-(void) rewindWithMarker:(NSInteger) marker
{
	markDepth--;
	[self seek:marker];
}

-(void) rewind
{
	[self seek:lastMarker];
}

-(void) seek:(NSInteger) i
{
	p = i;
}

@synthesize eof;

@end
