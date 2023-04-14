//
//  NoDataView.swift
//  FuelTracker
//
//

import Foundation
import SwiftUI

struct NoDataView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var newItemClick: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "tray.fill")
                        .foregroundColor(Color(UIColor.systemGray3))
                        .font(.some(Font.system(size:80,design: .rounded)))
                    
                    Text("No Data")
                        .font(.some(Font.system(.title,design: .rounded)))
                        .foregroundColor(.secondary)
                    Text("Add your first fuel or charge")
                        .foregroundColor(.secondary)
                        .font(.some(Font.system(.headline,design: .rounded)))
                        .multilineTextAlignment(.center)
                    
                    Button{
                        withAnimation {
                            self.newItemClick.toggle()
                        }
                    }label: {
                        HStack{
                            Image(systemName: "plus.circle")
                            Text("Add Fuel Stop")
                        }
                        .padding()
                        .foregroundColor(Color.appTheme)
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(newItemClick: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

