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
    
    func cornerRadius(radius: CGFloat, corner:UIRectCorner) -> some View{
        clipShape(RoundedCorner(radius: radius, corner: corner))    //pass in corner to curve radius
    }
    
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct RoundedCorner:Shape{
    var radius:CGFloat?
    var corner:UIRectCorner?
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner!, cornerRadii: CGSize(width: radius!, height: radius!))
        return Path(path.cgPath)
    }
}
