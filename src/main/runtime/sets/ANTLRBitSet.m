//
//  ANTLRBitSet.m
//  ANTLR
//
//  Created by Ian Michell on 21/03/2010.
//  Copyright 2010 Ian Michell, Kay Reopeke All rights reserved.

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

#import "ANTLRBitSet.h"

@interface ANTLRBitSet (Private)

@property(readwrite) CFMutableBitVectorRef bitVector;

@end

@implementation ANTLRBitSet

#pragma mark Constructors
-(id) init
{
	self = [super init];
	if (self)
	{
		bitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, 0);
	}
	return self;
}

-(ANTLRBitSet *) initWithBitVector:(CFMutableBitVectorRef) theVector
{
	self = [super init];
	if (self)
	{
		bitVector = theVector;
	}
	return self;
}

-(ANTLRBitSet *) initWithBits:(const unsigned long long const *) bits size:(NSUInteger) numberOfBits
{
	self = [self init];
	if (self)
	{
		NSUInteger longNo;
		CFIndex bitIndex;
		CFBitVectorSetCount(bitVector, sizeof(unsigned long long) * 8 * numberOfBits);
		
		for (longNo = 0; longNo < numberOfBits; longNo++)
		{
			for (bitIndex = 0; bitIndex < (CFIndex)sizeof(unsigned long long) * 8; bitIndex++)
			{
				unsigned long long swappedBits = CFSwapInt64HostToBig(bits[longNo]);
				if (swappedBits & (1LL << bitIndex))
				{
					CFBitVectorSetBitAtIndex(bitVector, bitIndex + (longNo * sizeof(unsigned long long) * 8), 1);
				}
			}
		}
	}
	return self;
}

-(ANTLRBitSet *) initWithArrayOfBits:(NSArray *) array
{
	self = [self init];
	if (self)
	{
		NSEnumerator *enumerator = [array objectEnumerator];
		id value;
		int bit = 0;
		while (value = [enumerator nextObject]) {
			if ([value boolValue] == YES) {
				CFBitVectorSetBitAtIndex(bitVector,bit,1);
			}
			bit++;
		}
	}
	return self;
}

-(void) dealloc
{
	CFRelease(bitVector);
	[super dealloc];
}

#pragma mark Operations
-(ANTLRBitSet *) or:(ANTLRBitSet *) aBitSet
{
	ANTLRBitSet *bitSetCopy = [self copy];
	[bitSetCopy orInPlace:aBitSet];
	return bitSetCopy;
}

-(void) orInPlace:(ANTLRBitSet *) aBitSet
{
	CFIndex count = CFBitVectorGetCount(bitVector);
	CFIndex otherCount = CFBitVectorGetCount(aBitSet.bitVector);
	
	CFIndex maxBitCount = count > otherCount ? count : otherCount;
	CFBitVectorSetCount(bitVector, maxBitCount);
	
	CFIndex i;
	for (i = 0; i < maxBitCount; i++)
	{
		if (CFBitVectorGetBitAtIndex(bitVector, i) | CFBitVectorGetBitAtIndex(aBitSet.bitVector, i))
		{
			CFBitVectorSetBitAtIndex(bitVector, i, 1);
		}
	}
}

-(void) add:(NSUInteger) bit
{
	if ((CFIndex)bit > CFBitVectorGetCount(bitVector))
	{
		CFBitVectorSetCount(bitVector, bit);
	}
	CFBitVectorSetBitAtIndex(bitVector, bit, 1);
}

-(void) remove:(NSUInteger) bit
{
	CFBitVectorSetBitAtIndex(bitVector, bit, 0);
}

-(NSUInteger) size
{
	return CFBitVectorGetCount(bitVector);
}

#pragma mark Information
-(unsigned long long) bitMask:(NSUInteger) bitNumber
{
	return 1LL << bitNumber;
}

-(BOOL) isMember:(NSUInteger) bitNumber
{
	return CFBitVectorGetBitAtIndex(bitVector, bitNumber) ? YES : NO;
}

-(BOOL) isNil
{
	return CFBitVectorGetCountOfBit(bitVector, CFRangeMake(0, CFBitVectorGetCount(bitVector)), 1) == 0 ? YES : NO;
}

-(NSString *) toString
{
	CFIndex length = CFBitVectorGetCount(bitVector);
	CFIndex currBit;
	NSMutableString *descString = [[NSMutableString alloc] initWithString:@"{"];
	BOOL haveInsertedBit = false;
	for (currBit = 0; currBit < length; currBit++) {
		if (CFBitVectorGetBitAtIndex(bitVector,currBit)) {
			if (haveInsertedBit) {
				[descString appendString:@","];
			}
			[descString appendString:[NSString stringWithFormat:@"%d", currBit]];
			haveInsertedBit = YES;
		}
	}
	[descString appendString:@"}"];
	return descString;
}

-(NSString *) description
{
	return [self toString];
}

#pragma mark NSCopying support

-(id) copyWithZone:(NSZone *) theZone
{
	ANTLRBitSet *newBitSet = [[ANTLRBitSet allocWithZone:theZone] initWithBitVector:CFBitVectorCreateMutableCopy(kCFAllocatorDefault,0,bitVector)];
	return newBitSet;
}

@end
