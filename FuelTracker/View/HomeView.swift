//
//  HomeView.swift
//  FuelTracker
//
//

import SwiftUI

struct HomeView: View {
    
    @FetchRequest(entity: Fuel.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Fuel.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var fuels: FetchedResults<Fuel>
    
    @EnvironmentObject var fuelViewModel: FuelViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        NavigationView{
            ZStack {
                if fuels.count == 0 {
                    Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                    NoDataView(newItemClick: $fuelViewModel.showAddNewFuelStopView)
                        .edgesIgnoringSafeArea(.all)
                }else{
                    List{
                        ForEach(group(fuels), id: \.self) { (section: [Fuel]) in  //Works but not ordered
                            Section(header: Text(section[0].date!.getCurrentMonthAndYear())) {
                                ForEach(section, id: \.self) { fuel in
                                    FuelCardView(fuel: fuel)
                                }
                            }
                        }
                    }
                }
            }

            .navigationTitle(settingsViewModel.fuelType == .electric ? "Charge Stops" : "Fuel Stops")
            .toolbar(content: {

                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        NavigationLink(destination:
                                        TutorialView()){
                            Image(systemName: "questionmark.circle")
                            
                        }
                        
                        if !AppUserDefaults.isPremiumUser {
                            Button{
                                withAnimation{
                                    fuelViewModel.showSubscriptionView = true
                                }
                            }label: {
                                Image(systemName: "crown")
                            }
                        }
                    }
                    
                }


                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        fuelViewModel.resetData()
                        withAnimation{
                            fuelViewModel.showAddNewFuelStopView = true
                        }
                    }label: {
                        Image(systemName: "plus.circle")
                    }.sheet(isPresented: $fuelViewModel.showAddNewFuelStopView){
                    } content: {
                        AddNewFuelStopView()
                            .environmentObject(fuelViewModel)
                    }
                }
            })
        }
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $fuelViewModel.showSubscriptionView, content: {

            PaymentView()
        })
    }
    
    func group(_ result : FetchedResults<Fuel>) -> [[Fuel]] {
        let sorted = result.sorted { $0.date! > $1.date! }
        
        return Dictionary(grouping: sorted) { (element : Fuel)  in
            element.date!.getCurrentMonthAndYear()
        }.sorted { $0.key < $1.key }.map(\.value)
    }
    
    
    @ViewBuilder
    func FuelCardView(fuel: Fuel) -> some View{
        VStack{
            HStack{
                Image(systemName: "fuelpump.fill")
                    .foregroundColor(Color.appTheme)
                Text(String(format: "%.2f", fuel.fuelAmount))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(settingsViewModel.fuelType == .electric ? "kWh" : "L")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(String(format: "%.2f", fuel.cost))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(fuelViewModel.costSymbol)
                    .foregroundColor(.secondary)
                
            }
            .padding(.top, 10)
            
            HStack {
                HStack{
                    Text(fuel.date!.getFormattedDate())
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(fuel.date!.getFormattedTime())
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                
                Spacer()
                
                HStack{
                    let costPerLitre = fuel.cost / fuel.fuelAmount
                    Text(String(format: "%.3f", costPerLitre))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(fuelViewModel.costSymbol)/\(settingsViewModel.fuelType == .electric ? "kWh" : "L")")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
            }
            .padding(.bottom, 10)
        }
        .contentShape(Rectangle())
        .onTapGesture{
            fuelViewModel.editFuel = fuel
            fuelViewModel.restoreEditData()
            fuelViewModel.showAddNewFuelStopView.toggle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
