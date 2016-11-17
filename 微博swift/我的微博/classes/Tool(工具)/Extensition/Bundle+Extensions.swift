//
//  Bundle+Extensions.swift
//  反射机制
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation

extension Bundle {

    // 计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
