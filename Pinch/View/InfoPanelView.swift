//
//  InfoPanelView.swift
//  Pinch
//
//  Created by Ayush Patra on 19/02/23.
//

import SwiftUI

struct InfoPanelView: View {
    var scale : CGFloat
    var offset : CGSize
    
    @State private var ShowDetails : Bool = false
    
    @State private var haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        HStack {
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(perform: {
                    withAnimation(.easeInOut){
                        ShowDetails.toggle()
                        haptics.notificationOccurred(.success)
                    }
                })
            
            if ShowDetails {
                withAnimation(.spring()){
                    HStack(spacing: 2){
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                        Text("\(scale)")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.left.and.right")
                        Text("\(offset.width)")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.and.down")
                        Text("\(offset.height)")
                    }
                    .font(.footnote)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .frame(maxWidth: 420)
                    
                }
                
            }
            
            Spacer()
        }
        .padding()
            
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
    }
}
