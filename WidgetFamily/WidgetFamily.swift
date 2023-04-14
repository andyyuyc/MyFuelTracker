//
//  WidgetFamily.swift
//  WidgetFamily
//
//  Created by Asil Arslan on 5.06.2022.
//

import WidgetKit
import SwiftUI

@main
struct WidgetFamily: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        AvgConsumptionWidget()
        OdometerWidget()
    }
}
