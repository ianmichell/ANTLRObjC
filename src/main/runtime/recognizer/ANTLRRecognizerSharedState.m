//
//  ANTLRRecognizerSharedState.m
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

#import "ANTLRRecognizerSharedState.h"


@implementation ANTLRRecognizerSharedState

@synthesize _fsp;
@synthesize following;
@synthesize ruleMemo;
@synthesize errorRecovery;
@synthesize failed;
@synthesize lastErrorIndex;
@synthesize syntaxErrors;
@synthesize backtracking;
@synthesize token;
@synthesize tokenStartCharIndex;
@synthesize tokenStartLine;
@synthesize tokenStartCharPositionInLine;
@synthesize channel;
@synthesize type;
@synthesize text;

-(id) init
{
	self = [super init];
	if (self)
	{
		self.following = [NSMutableArray new];
		self._fsp = -1;
		self.ruleMemo = [NSMutableArray new];
		self.errorRecovery = NO;
		self.lastErrorIndex = -1;
		self.failed = NO;
		self.backtracking = 0;
		self.tokenStartCharIndex = -1;
	}
	return self;
}

-(id) initWithState:(ANTLRRecognizerSharedState *) state
{
	self = [self init];
	if (self)
	{
		self.following = state.following;
		self._fsp = state._fsp;
		self.errorRecovery = state.errorRecovery;
		self.lastErrorIndex = state.lastErrorIndex;
		self.failed = state.failed;
		self.syntaxErrors = state.syntaxErrors;
		self.backtracking = state.backtracking;
		self.ruleMemo = state.ruleMemo;
		self.token = state.token;
		self.tokenStartCharIndex = state.tokenStartCharIndex;
		self.tokenStartCharPositionInLine = state.tokenStartCharPositionInLine;
		self.channel = state.channel;
		self.type = state.type;
		self.text = state.text;
	}
	return self;
}

-(void) dealloc
{
	[following release];
	[ruleMemo release];
	[super dealloc];
}

@end
