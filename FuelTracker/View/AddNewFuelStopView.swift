//
//  AddNewFuelStopView.swift
//  FuelTracker
//
//

import SwiftUI

struct AddNewFuelStopView: View {
    @FetchRequest(entity: Fuel.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Fuel.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var fuels: FetchedResults<Fuel>
    @EnvironmentObject var fuelViewModel: FuelViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.self) var env
    var body: some View {
        NavigationView{
            Form{
                Section(footer: Text(fuels.count > 0 ? "Last Odometer Entry: \(String(format: "%ld", locale: Locale.current, fuels.last!.odometer)) km" : "")) {
                    HStack {
                        Text("Cost:")
                        TextField("0", text: $fuelViewModel.cost)
                            .keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                        Text(fuelViewModel.costSymbol)
                    }
                    HStack {
                        Text(settingsViewModel.fuelType == .electric ? "Charge:" : "Fuel Amount:")
                        TextField("0", text: $fuelViewModel.fuelAmount)
                            .keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                        Text(settingsViewModel.fuelType == .electric ? "kWh" : "L")
                    }
                    HStack {
                        Text(settingsViewModel.fuelType == .electric ? "Full Charge:" : "Full Refill:")
                        Spacer()
                        Toggle(isOn:$fuelViewModel.fullRefill){
                            EmptyView()
                        }
                    }
                    HStack {
                        Text("Odometer:")
                        TextField(fuels.count > 0 ? String(format: "%ld", locale: Locale.current, fuels.last!.odometer) : "0", text: $fuelViewModel.odometer)
                            .keyboardType(.numberPad).multilineTextAlignment(.trailing)
                        Text("km")
                    }
                }
                
                Section{
                    DatePicker("Date:", selection: $fuelViewModel.date, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                    
                }
                
                if fuelViewModel.editFuel == nil {
                    HStack(spacing: 20){
                        HStack {
                            VStack(alignment: .leading){
                                HStack {
                                    Text(String(format: "%ld", locale: Locale.current, calculateDistance()))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text("km")
                                        .foregroundColor(.secondary)
                                }
                                Text("Distance")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))
                        HStack {
                            VStack(alignment: .leading){
                                HStack {
                                    Text(String(format: "%.3f", calculateFuelCost()))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text("\(fuelViewModel.costSymbol)/\(settingsViewModel.fuelType == .electric ? "kWh" : "L")")
                                        .foregroundColor(.secondary)
                                }
                                Text("Fuel Cost")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemGroupedBackground)))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .listRowInsets(EdgeInsets())
                }
                
                
                Section{
                    TextField("Notes (optional)", text: $fuelViewModel.notes)
                }
                if fuelViewModel.editFuel != nil {
                    Section{
                        Button{
                            if fuelViewModel.deleteFuel(context: env.managedObjectContext){
                                env.dismiss()
                            }
                        }label: {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(fuelViewModel.editFuel != nil ? settingsViewModel.fuelType == .electric ? "Edit Charge Stop" : "Edit Fuel Stop" : settingsViewModel.fuelType == .electric ? "New Charge Stop" : "New Fuel Stop")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        env.dismiss()
                    }label: {
                        Text("Cancel")
                            .foregroundColor(Color.appTheme)
                    }
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        withAnimation{
                            let count = fuels.count
//                            if count > 1 {
//                                var lastFuelStop: Fuel!
//
//                                if fuelViewModel.editFuel != nil {
//                                    lastFuelStop = fuels[count - 2]
//                                }else{
//                                    lastFuelStop = fuels[count - 1]
//                                }
//
//                                if Int32(fuelViewModel.odometer)! <= lastFuelStop!.odometer {
//                                    settingsViewModel.showAlert(title: "Odometer Value Error", message: "New odometer value must be greater than the old value. \nLast Odometer Entry: \(String(format: "%ld", locale: Locale.current, fuels.last!.odometer)) km")
//                                    return
//
//                                }
//                            }
                            if count > 2 {
                                if settingsViewModel.isPremium {
                                    if fuelViewModel.addFuelStop(context: env.managedObjectContext){
                                        env.dismiss()
                                    }
                                }else{
                                    fuelViewModel.showSubscriptionView.toggle()
                                }
                            }else{
                                if fuelViewModel.addFuelStop(context: env.managedObjectContext){
                                    env.dismiss()
                                }
                            }
                            
                            
                        }
                    }label: {
                        Text("Save")
                            .foregroundColor(Color.appTheme)
                    }
                    .disabled(!fuelViewModel.doneStatus())
                    .opacity(fuelViewModel.doneStatus() ? 1 : 0.6)
                }
            })
        }
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $fuelViewModel.showSubscriptionView, content: {
            
            PaymentView()
        })
        .alert(isPresented: $settingsViewModel.showAlert) {
            Alert(title: Text(LocalizedStringKey(settingsViewModel.title)), message: Text(LocalizedStringKey(settingsViewModel.message)), dismissButton: .default(Text(LocalizedStringKey(settingsViewModel.defaultButtonTitle))))
        }
    }
    
    func calculateFuelCost() -> Float{
        if let cost = Float(fuelViewModel.cost) {
            if let fuelAmount = Float(fuelViewModel.fuelAmount) {
                                        return (cost / fuelAmount)
            }
        }
        return 0
    }
    
    func calculateDistance() -> Int32{
        if fuels.count>0{
            
            let lastOdometer = fuels.last!.odometer
            if let odometer = Int32(fuelViewModel.odometer) {
                return odometer - lastOdometer
            }
        }
        
        return 0
    }
}

struct AddNewFuelStopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFuelStopView()
            .environmentObject(FuelViewModel())
    }
}
