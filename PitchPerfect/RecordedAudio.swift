//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Maryna Samushyia on 3/4/15.
//  Copyright (c) 2015 Maryna Samushyia. All rights reserved.
//

import Foundation

class RecordedAudio:NSObject{
    //vars
    var filePathUrl: NSURL!
    var title: String!
    
    //initializer or constructor
    init (filePath: NSURL, t: String){
        
       self.filePathUrl = filePath
       self.title = t
        
    }
}