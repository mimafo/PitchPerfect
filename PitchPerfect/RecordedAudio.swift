//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Michael Folcher on 11/1/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }

}
