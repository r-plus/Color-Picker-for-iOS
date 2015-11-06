/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $FreeBSD$
 */


#import "HRColorInfoView.h"
#import "HRColorPickerView.h"
#import "../../deletecut/deletecutsettings/HexColors/HexColors.h"

const CGFloat kHRColorInfoViewLabelHeight = 18.;
const CGFloat kHRColorInfoViewCornerRadius = 3.;

@interface HRColorInfoView () {
    UIColor *_color;
}
@end

@implementation HRColorInfoView {
    //UILabel *_hexColorLabel;
    CALayer *_borderLayer;
    UITextField *_hexLabelField;
}

@synthesize color = _color;

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor clearColor];
    //_hexColorLabel = [[UILabel alloc] init];
    //_hexColorLabel.backgroundColor = [UIColor clearColor];
    //_hexColorLabel.font = [UIFont systemFontOfSize:12];
    //_hexColorLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    //_hexColorLabel.textAlignment = NSTextAlignmentCenter;

    //[self addSubview:_hexColorLabel];

    _hexLabelField = [UITextField new];
    _hexLabelField.delegate = self;
    _hexLabelField.backgroundColor = [UIColor clearColor];
    _hexLabelField.font = [UIFont systemFontOfSize:12];
    _hexLabelField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _hexLabelField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hexLabelField];

    _borderLayer = [[CALayer alloc] initWithLayer:self.layer];
    _borderLayer.cornerRadius = kHRColorInfoViewCornerRadius;
    _borderLayer.borderColor = [[UIColor lightGrayColor] CGColor];
    _borderLayer.borderWidth = 1.f / [[UIScreen mainScreen] scale];
    [self.layer addSublayer:_borderLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //_hexColorLabel.frame = CGRectMake(
    _hexLabelField.frame = CGRectMake(
            0,
            CGRectGetHeight(self.frame) - kHRColorInfoViewLabelHeight,
            CGRectGetWidth(self.frame),
            kHRColorInfoViewLabelHeight);

    _borderLayer.frame = (CGRect) {.origin = CGPointZero, .size = self.frame.size};
}

//- (NSString *)hexStringFromColor:(UIColor *)color
//{
//    CGFloat r, g, b, a;
//    [color getRed:&r green:&g blue:&b alpha:&a];
//    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
//    return [NSString stringWithFormat:@"%06x", rgb];
//}

- (void)setColor:(UIColor *)color {
    _color = color;
    //_hexColorLabel.text = [NSString stringWithFormat:@"#%06x", rgb];
    _hexLabelField.text = [UIColor DC_hexWithColor:color];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect colorRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect) - kHRColorInfoViewLabelHeight);

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:colorRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    [rectanglePath closePath];
    [self.color setFill];
    [rectanglePath fill];
}

- (UIView *)viewForBaselineLayout {
    return _hexLabelField;
    //return _hexColorLabel;
}

// textFiel delegate
- (void)textFieldDidEndEditing:(UITextField * _Nonnull)textField
{
    UIColor *color = [UIColor DC_colorWithHexString:textField.text];
    if ([self.superview respondsToSelector:@selector(setColor:)])
        ((HRColorPickerView *)self.superview).color = color;
}

- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField
{
    return [_hexLabelField resignFirstResponder];
}
@end

