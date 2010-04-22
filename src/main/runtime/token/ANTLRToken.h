//
//  ANTLRToken.h
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
#import <ANTLR/ANTLRCharStream.h>

typedef enum {
	ANTLRTokenTypeEOF = -1,
	ANTLRTokenTypeInvalid = 0,
	ANTLRTokenTypeEOR = 1,
	ANTLRTokenTypeDOWN = 2,
	ANTLRTokenTypeUP = 3,
	ANTLRTokenTypeMIN = 4
} ANTLRTokenType;

typedef enum {
	ANTLRTokenChannelDefault = 0,
    ANTLRTokenChannelHidden = 99
} ANTLRTokenChannel;

@protocol ANTLRToken <NSObject>

// The singleton eofToken instance.
+(id<ANTLRToken>) eofToken;
// The default channel for this class of Tokens
+(ANTLRTokenChannel) defaultChannel;

@required
@property(readwrite, retain) NSString *text;
@property(readwrite) NSInteger type;
@property(readwrite) NSInteger line;
@property(readwrite) NSInteger charPositionInLine;
@property(readwrite) NSInteger channel;
@property(readwrite) NSInteger tokenIndex;

@optional
@property(readwrite, retain) id<ANTLRCharStream> inputStream;

@end