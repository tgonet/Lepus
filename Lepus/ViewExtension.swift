//
//  ViewExtension.swift
//  Lepus
//
//  Created by Aw Joey on 19/1/22.
//

import Foundation
import SwiftUI
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
