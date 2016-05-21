//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mark Lindamood on 2/11/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
