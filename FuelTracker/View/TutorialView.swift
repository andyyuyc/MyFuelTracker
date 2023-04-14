//
//  TutorialView.swift
//  FuelTracker
//
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                
                Text("1")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.appTheme)
                    .clipShape(Circle())
                
                
                Text("Press and Hold on your Home Screen to enter the jiggle mode, and tap on the **+** in the top right/left corner.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.35))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("2")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.appTheme)
                    .clipShape(Circle())
                
                
                Text("Scroll until you find this app \"Fuel Costs\"")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.35))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                
                Text("3")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.appTheme)
                    .clipShape(Circle())
                
                
                Text("Now just select the widget size, and tap on the \"Add Widget\" button")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.35))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                
            }
            .navigationBarTitle(Text(LocalizedStringKey("Widget Tutorial")), displayMode: .large)
            .padding()
        }//: ScrollView
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}


