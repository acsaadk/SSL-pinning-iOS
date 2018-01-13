//
//  DateTransformer.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransformer: DateFormatterTransform {
    
    init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = formatString
        super.init(dateFormatter: formatter)
    }
}
