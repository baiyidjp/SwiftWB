
//
//  Bundle+Extension.swift
//  SwiftTest
//
//  Created by tztddong on 2016/11/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

extension Bundle{

    func nameSpace(_ className: String) -> String {
        
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        
        return bundleName + "." + className
    }
    
    //计算属性
    var namespace: String {
        
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        return bundleName
    }
    
    
}
