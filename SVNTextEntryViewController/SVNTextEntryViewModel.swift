//
//  SVNTextEntryViewModel.swift
//  Tester
//
//  Created by Aaron Dean Bikis on 4/13/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit
public protocol SVNTextEntryViewModel {
    var seperatorColor: UIColor { get set }
    var headerTitle: String { get set }
    var confirmButtonTitle: String { get set }
}

internal struct SVNTextEntryVM: SVNTextEntryViewModel {
    var seperatorColor: UIColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
    var headerTitle: String = "Say something about our products!"
    var confirmButtonTitle: String = "Confirm"
}

