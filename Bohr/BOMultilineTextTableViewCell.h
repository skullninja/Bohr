//
//  BOMultilineTextTableViewCell.h
//  Bohr
//
//  Created by Dave Peck on 7/2/15.
//
//

#import "BOTableViewCell.h"

/// Defines an error after trying to input some new value to the cell text view.
typedef NS_ENUM(NSInteger, BOTextViewInputError) {
    BOTextViewInputTooShortError
};

@interface BOMultilineTextTableViewCell : BOTableViewCell <UITextViewDelegate>

/**
 * Block type defining an input error that has ocurred in the cell text field.
 *
 * @param cell the cell affected by the input error.
 * @param error the received input error.
 */
typedef void(^BOTextViewInputErrorBlock)(BOMultilineTextTableViewCell *cell, BOTextViewInputError error);

/// The text view on the cell.
@property (nonatomic, strong) UITextView *textView;

/// The minimum amount of non-blank characters necessary for the text view.
@property (nonatomic) IBInspectable NSInteger minimumTextLength;

/// A block defining an input error that has ocurred in the cell text view.
@property (nonatomic, copy) BOTextViewInputErrorBlock inputErrorBlock;

@end