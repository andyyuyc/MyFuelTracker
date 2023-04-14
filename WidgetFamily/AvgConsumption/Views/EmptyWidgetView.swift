//
//  EmptyWidgetView.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import SwiftUI

struct EmptyWidgetView: View {
    var body: some View {
        VStack{
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height:  50)
            
            Text("No fuel stop")
                .font(.footnote)
                .fontWeight(.semibold)
            
            Text("Add fuel stop from **plus** button")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.secondary)
//        .widgetURL(URL(string: "addHabit"))
    }
}

struct EmptyWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyWidgetView()
            .previewLayout(.sizeThatFits)
    }
}
