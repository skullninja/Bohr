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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

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
    
    self.placeholder = [UILabel new];
    self.placeholder.textAlignment = NSTextAlignmentRight;
    self.placeholder.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.placeholder];
    centerYConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.placeholder.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:15];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.placeholder.superview attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0];
    heightConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    
    self.placeholder.translatesAutoresizingMaskIntoConstraints = NO;
    [self.placeholder.superview addConstraints:@[heightConstraint, centerYConstraint, leftConstraint, rightConstraint]];
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (CGRectGetHeight(self.frame) >= [self expansionHeight]) {
        [self.placeholder setHidden:YES];
        [self.textView setHidden:NO];
    } else {
        [self.placeholder setHidden:NO];
        [self.textView setHidden:YES];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)updateAppearance {
    self.textView.textColor = self.secondaryColor;
    self.textView.tintColor = self.secondaryColor;
    self.placeholder.textColor = self.secondaryColor;
    
    if (self.secondaryFont) {
        self.textView.font = self.secondaryFont;
        self.placeholder.font = self.secondaryFont;
    }
}

- (void)settingValueDidChange {
    self.textView.text = self.setting.value;
    self.placeholder.text = [[self.setting.value componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
}

- (CGFloat)expansionHeight {
    return 140;
}

- (void)wasSelectedFromViewController:(BOTableViewController *)viewController {
    if (CGRectGetHeight(self.frame) >= [self expansionHeight]) {
        [self.textView setUserInteractionEnabled:YES];
        [self.textView becomeFirstResponder];
    }
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
    
    self.placeholder.text = [[self.setting.value componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    self.textView.userInteractionEnabled = NO;
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

@end
