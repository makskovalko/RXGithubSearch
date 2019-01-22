//
//  String+Extension.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
