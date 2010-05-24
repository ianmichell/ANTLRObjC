//
//  ANTLRStringStream.m
//  ANTLR
//
//  Created by Ian Michell on 21/03/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

// [The "BSD licence"]
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ANTLRStringStream.h"
#import "ANTLRCharStreamState.h"
#import "ANTLRError.h"


@implementation ANTLRStringStream

@synthesize charPositionInLine;
@synthesize line;
@synthesize sourceName;

-(id) init
{
	self = [super init];
	if (self)
	{
		[self reset];
	}
	return self;
}

-(void) dealloc
{
	if (markers != nil)
	{
		[markers release];
		markers = nil;
	}
	[data release];
	[super dealloc];
}

-(id) initWithInput:(NSString *) input
{
	self = [self init];
	if (self)
	{
		[input retain];
		data = input;
		n = [data length];
	}
	return self;
}

-(void) reset
{
	p = 0;
	line = 1;
	self.charPositionInLine = 0;
	markDepth = 0;
}

-(void) consume
{

	if (p < n)
	{
		charPositionInLine++;
		if ([data characterAtIndex:p] == '\n')
		{
			line++;
			charPositionInLine = 0;
		}
		p++;
	}
}

-(NSInteger) LA:(NSInteger) i
{
	if ( (p+i-1) >= [data length] ) {
		return ANTLRCharStreamEOF;
	}
	return (NSInteger)[data characterAtIndex:p+i-1];
}

-(NSInteger) LT:(NSInteger) i
{
	return [self LA:i];
}

-(NSInteger) mark
{
	if (markers == nil)
	{
		markers = [NSMutableArray new];
		NSNull *none = [NSNull null];
		[markers addObject:none];
		[none release]; // release from here...
	}
	markDepth++;
	ANTLRCharStreamState *state = nil;
	if (markDepth >= [markers count])
	{
		state = [ANTLRCharStreamState new];
		[markers addObject:state];
		[state release];
	}
	else 
	{
		state = (ANTLRCharStreamState *)[markers objectAtIndex:markDepth];
	}
	state.index = p;
	state.line = line;
	state.charPositionInLine = charPositionInLine;
	lastMarker = markDepth;
	return markDepth;
}

-(NSInteger) index
{
	return p;
}

-(void) rewind
{
	[self rewindWithMarker:lastMarker];
}

-(void) rewindWithMarker:(NSInteger) marker
{
	ANTLRCharStreamState *state = [markers objectAtIndex:marker];
	[self seek: state.index];
	line = state.line;
	charPositionInLine = state.charPositionInLine;
	[self releaseWithMarker:marker];
}


-(void) releaseWithMarker:(NSInteger) marker
{
	// unwind any other markers made after marker and release marker
	markDepth = marker;
	// release this marker
	markDepth--;
}

-(void) seek:(NSInteger) index
{
	if (index <= p)
	{
		p = index;
		return;
	}
	
	while (p < index)
	{
		[self consume];
	}
}

-(NSInteger) size
{
	return n;
}

-(NSString *) substring:(NSInteger) start stop:(NSInteger) stop
{
	return [data substringWithRange:NSMakeRange(start, stop)];
}


@end
