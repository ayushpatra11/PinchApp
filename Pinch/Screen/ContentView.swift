//
//  ContentView.swift
//  Pinch
//
//  Created by Ayush Patra on 19/02/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    
    //MARK: DRAG
    
    @State private var imageOffset : CGSize = .zero
    
    @State private var drawerOpen : Bool = false
    
    @State private var imageName : String = "magazine-front-cover"
    
    var Images : [String] = ["magazine-front-cover", "magazine-back-cover"]
    
    func resetImageState () {
        return withAnimation(.spring())
        {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    
    func chooseImage ( imageChosenName : String) {
        withAnimation(.spring()){
            self.imageName = imageChosenName
            self.drawerOpen = false
        }
        resetImageState()
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                
                    Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .padding()
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1.25), value: isAnimating)
                    .scaleEffect(imageScale)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }
                        else {
                            withAnimation(.spring()){
                                resetImageState()
                            }
                        }
                    })
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            withAnimation(.linear(duration: 1)){
                                imageOffset = gesture.translation
                            }
                        })
                            .onEnded({
                                _ in
                                if imageScale <= 1 {
                                    withAnimation(.spring()){
                                        resetImageState()
                                    }
                                }
                            })
                    )
                
                //MARK: Magnification gesture
                    .gesture(
                        MagnificationGesture()
                            .onChanged({
                                value in
                                withAnimation(.linear(duration: 0.4)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                        if imageScale > 5 {
                                            imageScale = 5
                                        }
                                        else if imageScale < 1 {
                                            imageScale = 1
                                        }
                                    }
                                    else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                    )
                    
//                    .animation(.linear(duration: 0.4), value: imageScale)
            }
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            })
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                ,alignment: .top
                
            )
            
            .overlay(Group{
                HStack{
                    Image(systemName: "minus.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            if imageScale > 2 {
                                withAnimation(.spring()){
                                    imageScale -= 1
                                }
                            }
                            else if imageScale == 2 {
                                resetImageState()
                            }
                            
                        }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            resetImageState()
                        }
                    
                    Spacer()
                    Image(systemName: "plus.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            if imageScale < 5 {
                                withAnimation(.spring()){
                                    imageScale += 1
                                }
                            }
                        }
                    
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .frame(maxWidth: 220)
            }
                .opacity(isAnimating ? 1 : 0)
                .padding(.bottom, 30)
                     ,alignment: .bottom
                
            )
            
            .overlay(
                HStack (spacing: 12){
                        Image(systemName: drawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(8)
                            .foregroundStyle(.secondary)
                            .onTapGesture(perform: {
                                withAnimation(.spring()){
                                    drawerOpen.toggle()
                                }
                            })
                    
                            DrawerImage(ImageName: Images[0])
                                .onTapGesture(perform: {
                                    chooseImage(imageChosenName: Images[0])
                            })
                    
                            DrawerImage(ImageName: Images[1])
                                .onTapGesture(perform: {
                                    chooseImage(imageChosenName: Images[1])
                            })
                        
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x : 20)
                    .frame(width : 280)
                    .padding(.top, UIScreen.main.bounds.height/12)
                    .offset(x: drawerOpen ? 20 : 215)
                ,alignment: .topTrailing
                
            )
            
        }//END OF NAV VIEW
        .navigationViewStyle(.stack)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DrawerImage: View {
    var ImageName : String
    var body: some View {
        Image(ImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 87)
            
    }
}
