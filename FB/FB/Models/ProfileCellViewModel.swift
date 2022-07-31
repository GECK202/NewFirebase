//
//  ProfileCellViewModel.swift
//  FB
//
//  Created by Valeria Karon on 7/31/22.
//

import UIKit

enum ProfileCellType {
    case info, status, buttons
}

struct ProfileCellViewModel {
    let type: ProfileCellType
    let height: CGFloat
    let cellIdentifier: String
}
