//
//  BOMultilineTextTableViewCell.m
//  Bohr
//
//  Created by Dave Peck on 7/2/15.
//
//

#import "BOMultilineTextTableViewCell.h"
#import "BOTableViewCell+Subclass.h"


@implementation BOMultilineTextTableViewCell

- (void)setup {
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentRight;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.userInteractionEnabled = NO;
    [self.textView setSelectable:YES];
    [self.textView setEditable:YES];
    [self.contentView addSubview:self.textView];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:15];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self expansionHeight]];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textView.superview addConstraints:@[heightConstraint, centerYConstraint, leftConstraint, rightConstraint]];
}

- (void)updateAppearance {
    self.textView.textColor = self.secondaryColor;
    self.textView.tintColor = self.secondaryColor;
    
    if (self.secondaryFont) {
        self.textView.font = self.secondaryFont;
    }
}

- (void)settingValueDidChange {
    self.textView.text = self.setting.value;
}

- (CGFloat)expansionHeight {
    return 200;
}

- (void)wasSelectedFromViewController:(BOTableViewController *)viewController {
    [self.textView setUserInteractionEnabled:YES];
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *filteredText = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (filteredText.length < self.minimumTextLength) {
        if (self.inputErrorBlock) self.inputErrorBlock(self, BOTextViewInputTooShortError);
        textView.text = self.setting.value;
    } else {
        self.setting.value = textView.text;
    }
    
    self.textView.userInteractionEnabled = NO;
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

@end
