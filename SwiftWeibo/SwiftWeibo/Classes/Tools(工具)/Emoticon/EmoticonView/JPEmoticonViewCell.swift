//
//  JPEmoticonViewCell.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPEmoticonViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    /// 当前页面的表情数组 最多20个
    var emoticons: [JPEmoticonModel]? {
        
        didSet {
            
            print("表情的数量--\(emoticons?.count ?? 0)")
            
            //先隐藏所有的按钮
            for btn in contentView.subviews {
                btn.isHidden = true
            }
            
            //遍历表情数组
            for (i,model) in (emoticons ?? []).enumerated() {
                
                if let btn = contentView.subviews[i] as? UIButton {
                    
                    //设置图像
                    btn.setImage(model.image, for: .normal)
                    //设置emoji的字符串(表情)
                    btn.setTitle(model.emoji, for: .normal)
                
                    btn.isHidden = false
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    /// 这句话的意思就是不使用XIB加载
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        //代码不在经过此处
        setupUI()
    }
}

// MARK: - 设置视图
fileprivate extension JPEmoticonViewCell {
    /*
        从XIB加载的cell bounds是xib中设置的大小 不是 size 的大小
        从纯代码中加载 bounds 就是布局属性中设置的 itemSize的大小
     */
    func setupUI() {
        
        let rowCount = 3 //行数
        let colCount = 7 //列数
        
        let leftMargin: CGFloat = 8 //左右间距
        let bottomMargin: CGFloat = 16 //底部间距 为分页控制器留下空间
        
        let btnW = (bounds.width - 2*leftMargin) / CGFloat(colCount) //按钮的宽
        let btnH = (bounds.height - bottomMargin) / CGFloat(rowCount) //按钮的高
        
        for i in 0..<rowCount*colCount {
            
            let row = i / colCount //行
            let col = i % colCount //列

            let btn = UIButton()
            
            let btnX = leftMargin + btnW * CGFloat(col) //按钮的X
            let btnY = btnH * CGFloat(row) //按钮的Y
            
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            
            //根据图片的大小确定
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            contentView.addSubview(btn)
        }
    }
}
