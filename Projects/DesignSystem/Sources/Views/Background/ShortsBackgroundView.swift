//
//  ShortsBackgroundView.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct ShortsBackgroundView: View {
  public init() { }
  
  public var body: some View {
    ZStack {
      Color(red: 222, green: 234, blue: 243)
        .edgesIgnoringSafeArea(.all)
      
      GeometryReader { geometry in
        // 좌측
        Circle()
          .fill(
            LinearGradient(
              gradient: Gradient(
                colors: [
                  Color(red: 183/255, green: 220/255, blue: 255/255, opacity: 1),
                  Color(red: 218/255, green: 237/255, blue: 255/255, opacity: 0.4)
                ]
              ),
              startPoint: UnitPoint(x: 0.3521, y: 0),
              endPoint: UnitPoint(x: 1, y: 1)
            )
          )
          .frame(width: 162, height: 162)
          .blur(radius: 37)
          .offset(x: -77, y: -25)
        
        Circle()
          .fill(
            Color(red: 160/255, green: 255/255, blue: 249/255, opacity: 0.3)
          )
          .frame(width: 109, height: 109)
          .blur(radius: 37)
          .offset(x: -33, y: 317)
        
        Circle()
          .fill(
            Color(red: 45/255, green: 205/255, blue: 255/255, opacity: 0.1)
          )
          .frame(width: 139, height: 139)
          .blur(radius: 32)
          .offset(x: -40, y: 600)
        
        // 우측
        Circle()
          .fill(
            Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5)
          )
          .frame(width: 191, height: 191)
          .blur(radius: 32)
          .offset(x: 267, y: 55)
        
        Circle()
          .fill(
            Color(red: 255/255, green: 229/255, blue: 163/255, opacity: 0.8)
          )
          .frame(width: 121, height: 121)
          .blur(radius: 37)
          .offset(x: 317, y: 145)
        
        Circle()
          .fill(
            LinearGradient(
              gradient: Gradient(
                colors: [
                  Color(red: 45/255, green: 179/255, blue: 255/255, opacity: 1),
                  Color(red: 45/255, green: 179/255, blue: 255/255, opacity: 0)
                ]
              ),
              startPoint: UnitPoint(x: 0.6094, y: 0.5909),
              endPoint: UnitPoint(x: 0.1696, y: 0.7273)
            )
          )
          .frame(width: 198, height: 198)
          .opacity(0.5)
          .blur(radius: 67)
          .offset(x: 222, y: 649)
      }
    }
  }
}

public extension View {
  func shortsBackgroundView() -> some View {
    ZStack {
      ShortsBackgroundView()
      self
    }    
  }
}
