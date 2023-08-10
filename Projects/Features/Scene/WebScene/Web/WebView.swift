//
//  WebView.swift
//  Web
//
//  Created by GREEN on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct WebView: View {
  private let store: Store<WebState, WebAction>
  
  public init(store: Store<WebState, WebAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        VStack {
          TopNavigationBar(
            leftIcon: DesignSystem.Icons.iconNavigationLeft,
            leftIconButtonAction: { viewStore.send(.backButtonTapped(viewStore.source)) },
            rightText: "저장",
            rightIconButtonAction: { viewStore.send(.saveButtonTapped) },
            isRightButtonActive: viewStore.binding(
              get: \.saveButtonDisabled,
              send: { WebAction._setSaveButtonDisabled($0) }
            )
          )
          
          ShortsWebView(webAddress: viewStore.state.webAddress)
        }
        .apply(content: { view in
          WithViewStore(store.scope(state: \.saveToastMessage)) { saveToastMessageViewStore in
            view.toast(
              text: saveToastMessageViewStore.state,
              toastType: .info
            )
          }
        })
        .apply(content: { view in
          WithViewStore(store.scope(state: \.warningToastMessage)) { warningToastMessageViewStore in
            view.toast(
              text: warningToastMessageViewStore.state,
              toastType: .warning
            )
          }
        })
        
        if viewStore.state.isDisplayTooltip {
          TooltipView(store: store)
            .padding(.top, 33)
            .padding(.trailing, 4)
        }
      }
      .onAppear { viewStore.send(._onAppear) }
    }
    .navigationBarHidden(true)
  }
}

// MARK: - Tooltip View
private struct TooltipView: View {
  private let store: Store<WebState, WebAction>
  
  fileprivate init(store: Store<WebState, WebAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        HStack {
          Spacer()
          
          TooltipShape()
            .onTapGesture {
              viewStore.send(.tooltipButtonTapped)
            }
        }
        Spacer()
      }
    }
  }
}

// MARK: - Tooltip Shape
private struct TooltipShape: View {
  fileprivate var body: some View {
    ZStack {
      CustomTriangleShape()
        .fill(DesignSystem.Colors.blue200)
        .padding(.leading, 178)
      
      CustomRectangleShape()
    }
    .frame(width: 216, height: 45)
  }
}

// MARK: - Custom Rectangle Shape
private struct CustomRectangleShape: View {
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      Text("개별 뉴스를 저장해보세요!")
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 20).fill(DesignSystem.Colors.blue200))
    }
  }
}

// MARK: - Custom Triangle Shape
private struct CustomTriangleShape: Shape {
  fileprivate func path(in rect: CGRect) -> Path {
    var path = Path()
    let width: CGFloat = 24
    let height: CGFloat = 24
    let radius: CGFloat = 1
    
    path.move(to: CGPoint(x: rect.minX + width / 2 - radius, y: rect.minY))
    path.addQuadCurve(
      to: CGPoint(x: rect.minX + width / 2 + radius, y: rect.minY),
      control: CGPoint(x: rect.minX + width / 2, y: rect.minY + radius)
    )
    path.addLine(to: CGPoint(x: rect.minX + width, y: rect.minY + height))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + height))
    
    path.closeSubpath()
    
    return path
  }
}
