//
//  ANTLRCommonTree.m
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

#import "ANTLRCommonTree.h"
#import "ANTLRCommonToken.h"

@implementation ANTLRCommonTree

-(id) init
{
	self = [super init];
	if (self)
	{
		self.tokenStartIndex = -1;
		self.tokenStopIndex = -1;
		self.childIndex = -1;
	}
	return self;
}

-(id) initWithCommonTreeNode:(ANTLRCommonTree *) node
{
	self = [self initWithTree:node];
	if (self)
	{
		self.token = node.token;
		self.tokenStartIndex = node.tokenStartIndex;
		self.tokenStopIndex = node.tokenStopIndex;
	}
	return self;
}

-(id) initWithToken:(id<ANTLRToken>) t
{
	self = [self init];
	if (self)
	{
		self.token = t;
	}
	return self;
}

-(id) initWithTokenType:(NSInteger) t
{
	self = [self init];
	if (self)
	{
		ANTLRCommonToken *tmpToken = [[ANTLRCommonToken alloc] init];
		tmpToken.type = t;
		self.token = tmpToken;
		[tmpToken release];
	}
	return self;
}

-(id) copyWithZone:(NSZone *)aZone
{
	return [[ANTLRCommonTree allocWithZone:aZone] initWithCommonTreeNode:self];
}

-(NSString *) description
{
	if (self.isEmpty)
	{
		return @"nil";
	}
	if (self.type == ANTLRTokenTypeInvalid)
	{
		return @"<errornode>";
	}
	if (self.token == nil)
	{
		return nil;
	}
	return self.token.text;
}

@synthesize token;

/*******************************************************************************
 *	Dynamic properties
 ******************************************************************************/
@dynamic isEmpty;
-(BOOL) isEmpty
{
	return self.token == nil;
}

@dynamic type;
-(NSInteger) type
{
	if (self.token == nil)
	{
		return ANTLRTokenTypeInvalid;
	}
	return token.type;
}

@dynamic charPositionInLine;
-(NSInteger) charPositionInLine
{
	if (self.token == nil || self.token.charPositionInLine == -1)
	{
		if (self.childCount > 0)
		{
			return [self childAtIndex:0].charPositionInLine;
		}
		return 0;
	}
	return self.token.line;
}

@dynamic tokenStartIndex;
-(NSInteger) tokenStartIndex
{
	if (tokenStartIndex == -1 && self.token != nil)
	{
		return self.token.tokenIndex;
	}
	return tokenStartIndex;
}

-(void) setTokenStartIndex:(NSInteger) s
{
	tokenStartIndex = s;
}

@dynamic tokenStopIndex;
-(NSInteger) tokenStopIndex
{
	if (tokenStopIndex == -1 && self.token != nil)
	{
		return self.token.tokenIndex;
	}
	return tokenStopIndex;
}

-(void) setTokenStopIndex:(NSInteger) s
{
	tokenStopIndex = s;
}

@dynamic line;
-(NSInteger) line
{
	if (self.token == nil || self.token.line == 0)
	{
		if (self.childCount > 0)
		{
			return [self childAtIndex:0].line;
		}
		return 0;
	}
	return self.token.line;
}

@dynamic text;
-(NSString *) text
{
	if (self.token == nil)
	{
		return nil;
	}
	return self.token.text;
}

@end

