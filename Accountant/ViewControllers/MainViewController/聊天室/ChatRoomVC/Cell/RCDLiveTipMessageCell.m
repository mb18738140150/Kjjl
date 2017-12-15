//
//  RCDLiveTipMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/29.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveTipMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"
@interface RCDLiveTipMessageCell ()<RCDLiveAttributedLabelDelegate>
@end

@implementation RCDLiveTipMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [RCDLiveTipLabel greyTipLabel];
        self.tipMessageLabel.textAlignment = NSTextAlignmentLeft;
//        self.tipMessageLabel.delegate = self;
        self.tipMessageLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.tipMessageLabel];
        self.tipMessageLabel.font = [UIFont systemFontOfSize:14.f];;
        self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
        
//        self.tipMessageLabel.backgroundColor = [UIColor blueColor];
        
        self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 5, 22)];
        [self.baseContentView addSubview:self.timeLB];
        self.timeLB.backgroundColor = [UIColor clearColor];
        self.timeLB.textAlignment = NSTextAlignmentRight;
        self.timeLB.textColor = UIRGBColor(150, 150, 150);
        self.timeLB.font = kMainFont;
        
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];

    RCMessageContent *content = model.content;
    if ([content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)content;
        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        self.tipMessageLabel.text = localizedMessage;
        self.tipMessageLabel.textColor = RCDLive_HEXCOLOR(0xffb83c);
    }else if ([content isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage *notification = (RCTextMessage *)content;
        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        NSString *name=@"";
        NSString * dateStr = @"";
        if (content.senderUserInfo) {
            
            /*
             //            if (notification.extra) {
             //                switch (notification.extra.intValue) {
             //                    case 1:
             //                        name = [NSString stringWithFormat:@"注册-%@:",content.senderUserInfo.name];
             //                        break;
             //                    case 2:
             //                        name = [NSString stringWithFormat:@"试用-%@:",content.senderUserInfo.name];
             //                        break;
             //                    case 3:
             //                        name = [NSString stringWithFormat:@"正式会员-%@:",content.senderUserInfo.name];
             //                        break;
             //
             //                    default:
             //                        name = [NSString stringWithFormat:@"%@:",content.senderUserInfo.name];
             //                        break;
             //                }
             //            }else
             //            {
             //            }
             */
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.sentTime / 1000.0];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"HH:mm:ss";
            dateStr = [formatter stringFromDate:date];
            dateStr = [NSString stringWithFormat:@"%@  ", dateStr];
            
            name = [NSString stringWithFormat:@"%@:",content.senderUserInfo.name];
        }
        
        NSString *str =[NSString stringWithFormat:@"%@\n    %@",name,localizedMessage];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
//        if (notification.extra) {
//            switch (notification.extra.intValue) {
//                case 1:
//                    [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x1D7AF8)) range:[str rangeOfString:name]];
//                    break;
//                case 2:
//                    [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x00FF00)) range:[str rangeOfString:name]];
//                    break;
//                case 3:
//                    [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0xFF0000)) range:[str rangeOfString:name]];
//                    break;
//                    
//                default:
//                    [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x1D7AF8)) range:[str rangeOfString:name]];
//                    break;
//            }
//        }else
//        {
//        }
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(UIRGBColor(255, 102, 10)) range:[str rangeOfString:name]];
        if ([model.senderUserId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kAssistantID]]) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0xFF0000)) range:[str rangeOfString:name]];
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:(kMainTextColor) range:[str rangeOfString:localizedMessage]];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:[str rangeOfString:localizedMessage]];
        
        self.tipMessageLabel.attributedText = attributedString.copy;
        self.timeLB.text = dateStr;
    }else if ([content isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)content;
        NSString *name=@"";
        if (content.senderUserInfo) {
            name = content.senderUserInfo.name;
        }
        NSString *localizedMessage = @"送了一个钻戒";
        if(notification && [notification.type isEqualToString:@"1"]){
          localizedMessage = @"为主播点了赞";
        }
        
        NSString *str =[NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x1D7AF8)) range:[str rangeOfString:name]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0xf719ff)) range:[str rangeOfString:localizedMessage]];
        self.tipMessageLabel.attributedText = attributedString.copy;
    }

    NSString *__text = self.tipMessageLabel.text;
    
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:__text];
    
    if (_isFullScreenMode) {
        self.tipMessageLabel.frame = CGRectMake(6,0, __labelSize.width, __labelSize.height);
//        self.tipMessageLabel.backgroundColor = RCDLive_HEXCOLOR(0x000000);
//        self.tipMessageLabel.alpha = 0.5;

    }else{
        self.tipMessageLabel.frame = CGRectMake((self.baseContentView.bounds.size.width - __labelSize.width) / 2.0f,0, __labelSize.width, __labelSize.height);
//        self.tipMessageLabel.backgroundColor = RCDLive_HEXCOLOR(0xBBBBBB);
//        self.tipMessageLabel.alpha = 1;
    }
}

- (NSString *)getSpaceStr:(NSString *)name and:(NSString *)timeStr
{
    NSString * space = @"                        ";
    int length = 16 - name.length - 1 - timeStr.length;
    if (length <0) {
        length = 0;
    }
    NSString *space1 = [space substringWithRange:NSMakeRange(0, length)];
    
    return space1;
}

- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    
}

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getTipMessageCellSize:(NSString *)content{
    CGFloat maxMessageLabelWidth = kScreenWidth;
    CGSize __textSize = CGSizeZero;
    if (RCDLive_IOS_FSystenVersion < 7.0) {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:14.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    }else {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:14.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT));
    }
    
//    CGFloat height = [UIUtility getLineSpaceLabelHeght:content font:kMainFont width:maxMessageLabelWidth];
    
    __textSize = CGSizeMake(ceilf(__textSize.width)+10 , ceilf(__textSize.height) + 6);    return __textSize;
}
@end
