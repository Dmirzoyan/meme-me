//
//  SharedImagesGridPresenter.swift
//  MemeMe
//
//  Created by Davit Mirzoyan on 2/26/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

protocol SharedImagesGridDisplaying {
    func display(_ sharedImages: [SharedImage])
}

final class SharedImagesGridPresenter: SharedImagesGridPresenting {
    
    private let display: SharedImagesGridDisplaying
    
    init(display: SharedImagesGridDisplaying) {
        self.display = display
    }
    
    func present(_ sharedimages: [SharedImage]) {
        display.display(sharedimages)
    }
}
