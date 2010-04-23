//
//  ANTLRCommonToken.m
//  ANTLR
//
//  Created by Ian Michell on 21/04/2010.
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
#import "ANTLRCommonToken.h"


@implementation ANTLRCommonToken

+(id<ANTLRToken>) eofToken
{
	return [[ANTLRCommonToken alloc] initWithTokenType: ANTLRTokenTypeEOF];
}

+(ANTLRTokenChannel) defaultChannel
{
	return ANTLRTokenChannelDefault;
}

-(id) init
{
	self = [super init];
	if (self)
	{
		self.tokenIndex = -1;
		self.charPositionInLine = -1;
	}
	return self;
}

-(id) initWithTokenType:(NSInteger) aType
{
	self = [super init];
	if (self)
	{
		self.type = aType;
	}
	return self;
}

-(id) initWithTokenType:(NSInteger) aType andText:(NSString *) txt
{
	self = [self initWithTokenType:aType];
	if (self)
	{
		self.channel = [ANTLRCommonToken defaultChannel];
		self.text = txt;
	}
	return self;
}

-(id) initWithCharStream:(id<ANTLRCharStream>) input type:(NSInteger) aType channel:(NSInteger) aChannel start:(NSInteger) theStart stop:(NSInteger) theStop
{
	self = [self initWithTokenType:aType];
	if (self)
	{
		self.inputStream = input;
		self.channel = aChannel;
		self.start = theStart;
		self.stop = theStop;
	}
	return self;
}

-(id) initWithToken:(id<ANTLRToken>) oldToken
{
	self = [super init];
	if (self)
	{
		self.text = oldToken.text;
		self.type = oldToken.type;
		self.line = oldToken.line;
		self.tokenIndex = oldToken.tokenIndex;
		self.charPositionInLine = oldToken.charPositionInLine;
		self.channel = oldToken.channel;
		if ([oldToken isKindOfClass:[ANTLRCommonToken class]])
		{
			self.start = ((ANTLRCommonToken *)oldToken).start;
			self.stop = ((ANTLRCommonToken *)oldToken).stop;
		}
	}
	return self;
}

@dynamic text;
-(NSString *) text
{
	// If text is set, then return it.
	if (text != nil)
	{
		return text;
	}
	// If not check that the input stream is set, if not return nil
	if (self.inputStream == nil)
	{
		return nil;
	}
	// If there is an input stream, then return a substring from it.
	text = [self.inputStream substring:self.start stop:self.stop];
	return text;
}

-(void) setText:(NSString *) txt
{
	text = txt;
}

-(NSString *) description
{
	NSString *channelStr = @"";
	if (self.channel > 0)
	{
		channelStr = @",channel=" + self.channel;
	}
	NSMutableString *txt = nil;
	if (self.text != nil)
	{
		txt = [NSMutableString stringWithString:self.text];
		[txt replaceOccurrencesOfString:@"\n" withString:@"\\\n" options:NSAnchoredSearch range:NSMakeRange(0, [txt length])];
		[txt replaceOccurrencesOfString:@"\r" withString:@"\\\r" options:NSAnchoredSearch range:NSMakeRange(0, [txt length])];
		[txt replaceOccurrencesOfString:@"\t" withString:@"\\\t" options:NSAnchoredSearch range:NSMakeRange(0, [txt length])];
	}
	else 
	{
		txt = [NSMutableString stringWithString:@"<no text>"];
	}
	return [NSString stringWithFormat:@"[@%d,%d,%d,%@,<%d>%@,%d,%d]", self.tokenIndex, self.start, self.stop, txt, self.type, channelStr, self.line, self.charPositionInLine];

}

@synthesize type;
@synthesize line;
@synthesize charPositionInLine;
@synthesize channel;
@synthesize tokenIndex;
@synthesize inputStream;

@synthesize start;
@synthesize stop;

@end
