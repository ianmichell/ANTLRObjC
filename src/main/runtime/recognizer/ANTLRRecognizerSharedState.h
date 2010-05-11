//
//  ANTLRRecognizerSharedState.h
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

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRToken.h>

@interface ANTLRRecognizerSharedState : NSObject 
{
	NSMutableArray *following;
	NSMutableArray *ruleMemo;
	NSInteger _fsp;
	
	BOOL errorRecovery;
	BOOL failed;
	NSInteger lastErrorIndex;
	NSInteger syntaxErrors;
	NSInteger backtracking;
	id<ANTLRToken> token;
	NSInteger tokenStartCharIndex;
	NSInteger tokenStartLine;
	NSInteger tokenStartCharPositionInLine;
	ANTLRTokenChannel channel;
	ANTLRTokenType type;
	NSString *text;
}

-(id) initWithState:(ANTLRRecognizerSharedState *) state;

@property(readwrite, retain) NSMutableArray *following;
@property(readwrite) NSInteger _fsp; // what is this?
@property(readwrite, retain) NSMutableArray *ruleMemo;
@property(readwrite) BOOL errorRecovery;
@property(readwrite) BOOL failed;
@property(readwrite) NSInteger lastErrorIndex;
@property(readwrite) NSInteger syntaxErrors;
@property(readwrite) NSInteger backtracking;
@property(readwrite, retain) id<ANTLRToken> token;
@property(readwrite) NSInteger tokenStartCharIndex;
@property(readwrite) NSInteger tokenStartLine;
@property(readwrite) NSInteger tokenStartCharPositionInLine;
@property(readwrite) ANTLRTokenChannel channel;
@property(readwrite) ANTLRTokenType type;
@property(readwrite, retain) NSString *text;


@end
