//
//  PageTypeViewModel.swift
//  FuelTracker
//
//

import Foundation

class PageTypeViewModel: ObservableObject{
    @Published var pageType: PageType = PageType.splash
    
    init(){
        if AppUserDefaults.shouldShowWelcomeScreen{
            pageType = PageType.welcome
        }else{
            pageType = PageType.splash
        }
    }
    
    func goTabScreen(){
        pageType = .home
    }
    
    func onClickContinue(){
        AppUserDefaults.shouldShowWelcomeScreen = false
        pageType = .home
    }
}

enum PageType{
    case welcome
    case splash
    case home
}

