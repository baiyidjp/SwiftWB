//
//  JPStatusCell.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPStatusCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// VIP图标
    @IBOutlet weak var vipImage: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 文本
    @IBOutlet weak var statusLabel: UILabel!
    /// 头像上的认证图标
    @IBOutlet weak var verifiedImage: UIImageView!
    /// 底部工具栏
    @IBOutlet weak var statusToolBar: JPStatusToolBar!
    /// 配图视图
    @IBOutlet weak var pictureView: JPStatusPictureView!
    /// 被转发微博文本 -- 原创微博没有这个 不能用 ! 应该用 /.
    @IBOutlet weak var retweetLabel: UILabel?
    
    
    /// 单条微博的视图模型
    var statusViewModel: JPStatusViewModel? {
        
        didSet {
            /// 文本
            statusLabel?.text = statusViewModel?.status.text
            /// 昵称
            nameLabel.text = statusViewModel?.status.user?.screen_name
            /// 设置会员图标
            vipImage.image = statusViewModel?.memberImage
            /// 设置认证图标
            verifiedImage.image = statusViewModel?.verifiedImage
            /// 设置头像
            iconView.jp_setWebImage(urlString: statusViewModel?.status.user?.profile_image_url, placeholderImage: #imageLiteral(resourceName: "avatar_default"),isRound: true)
            ///将模型赋值给bar
            statusToolBar.statusViewModel = statusViewModel
            /// 配图的视图模型
            pictureView.statusViewModel = statusViewModel
            /// 配图的URLS
            //测试4张图
//            if statusViewModel?.status.pic_urls?.count ?? 0 > 4 {
//                
//                var urls = statusViewModel?.status.pic_urls!
//                urls?.removeSubrange(((urls?.startIndex)!+4)..<(urls?.endIndex)!)
//                pictureView.picUrls = urls
//            }else{
//                pictureView.picUrls = statusViewModel?.status.pic_urls
//            }
            //正常显示图片  (有转发的时候使用转发)
            pictureView.picUrls = statusViewModel?.picURLs
            
            //被转发微博的文本
            retweetLabel?.text = statusViewModel?.retweetText
        }
    }
    
    /*
        关于表格的性能优化 (使用内存换取CPU)
        1 -- 尽量少计算,所有需要的素材提前计算好(使用ViewModel在其中先行计算好)
        2 -- 控件上不要设置圆角半径,所有图像渲染的属性,都要注意
        3 -- 不要在列表滚动后动态创建控件,所有需要的控件,都要提前创建好,在显示的时候,根据数据 显示/隐藏
        4 -- cell中控件的层次越少越好,数量越少越好
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
