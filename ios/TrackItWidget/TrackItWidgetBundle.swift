//
//  TrackItWidgetBundle.swift
//  TrackItWidget
//
//  Created by DART GUY on 3/10/25.
//

import WidgetKit
import SwiftUI

@main
struct TrackItWidgetBundle: WidgetBundle {
    var body: some Widget {
        TrackItWidget()
        TrackItWidgetControl()
        TrackItWidgetLiveActivity()
    }
}
