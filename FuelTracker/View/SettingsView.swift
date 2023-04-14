//
//  SettingsView.swift
//  FuelTracker
//
//

import SwiftUI

var DEVELOPER = "Andy Yu"
var COMPABILITY = "iOS 15+"
var WEBSITE_LABEL = "Website"
var WEBSITE_LINK = "andyyuyc.com"

struct SettingsView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var themeType = AppUserDefaults.preferredTheme
    @State private var fuelType = AppUserDefaults.preferredFuelType
    @State private var color = Color(hex: AppUserDefaults.appThemeColor)
    @State private var showSubscriptionFlow: Bool = false
    
    var body: some View {
        NavigationView{
            List{

                Section(header:Text("Fuel Expense Tracker App")){

                    HStack(alignment:.top, spacing: 10) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(9)
                            .padding(.vertical)
                        VStack {
                            Text("MyFuelTrack provides an easy way to log your car's fuel expenses. Track fuel costs.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical)
                            Spacer()
                        }
                        Spacer()
                    }
                }

                if !AppUserDefaults.isPremiumUser {
                    Button(action: {
                        self.showSubscriptionFlow = true
                    }, label: {
                        PremiumHeader()
                    })
                        .listRowInsets(EdgeInsets())
                        .sheet(isPresented: $showSubscriptionFlow, content: {
                            PaymentView()
                        })
                }

                Section(header: Text("Preferences")){
                    
                    ColorPicker("Pick a Color", selection:$settingsViewModel.appThemeColor.onChange(colorChange))
                   

                    HStack{
                        Text("Theme")
                        Spacer()
                        Picker("", selection: $themeType.onChange(themeChange)){
                            Text("System").tag(0)
                            Text("Light").tag(1)
                            Text("Dark").tag(2)
                        }
                        .fixedSize()
                        .pickerStyle(.segmented)
                    }
                }

                Section(header: Text("Car Preferences")){

                    HStack{
                        Text("Engine")
                        Spacer()
                        Picker("", selection: $fuelType.onChange(fuelTypeChange)){
                            Text("Combustion").tag(0)
                            Text("Electric").tag(1)
                        }
                        .fixedSize()
                        .pickerStyle(.segmented)
                    }
                }

                Section(header: Text("Application")){

                    SettingsRowView(name: "Developer",content: DEVELOPER)
                    SettingsRowView(name: "Compability",content: COMPABILITY)
                    SettingsRowView(name: "Website", linkLabel: WEBSITE_LABEL, linkDestination: WEBSITE_LINK)
                    SettingsRowView(name: "Version",content: "\(Bundle.main.versionNumber) (Build \(Bundle.main.buildNumber))")

                }
            }
            .navigationBarTitle("Settings")
            
        }
        
        
    }
    
    func themeChange(_ tag: Int){
        settingsViewModel.changeAppTheme(theme: tag)
    }
    
    func fuelTypeChange(_ tag: Int){
        settingsViewModel.changeFuelType(fuelType: tag)
    }
    
    func colorChange(_ color: Color){
        settingsViewModel.changeAppColor(color: color)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


struct SettingsLabelView: View {
    
    var labelText: String
    var labelImage: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased())
            Spacer()
            Image(systemName: labelImage )
                .font(.headline)
        }
    }
}


struct SettingsRowView: View {
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            HStack{
                Text(LocalizedStringKey(name)).foregroundColor(.gray)
                Spacer()
                if content != nil {
                    Text(content!)
                } else if(linkLabel != nil && linkDestination != nil){
                    Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
                    Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
                } else {
                    EmptyView()
                }
            }
        }
    }
}


extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}


