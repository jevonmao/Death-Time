//
//  DeathTimeWidget.swift
//  DeathTimeWidget
//
//  Created by Jevon Mao on 12/30/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), timeUntilYear: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "\(2020)/12/30 23:59")!
        let difference = someDateTime.timeIntervalSince(Date())
        let entry = SimpleEntry(date: Date(), timeUntilYear: difference)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, timeUntilYear:   )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
 
struct SimpleEntry: TimelineEntry {
    var date: Date
    var timeUntilYear:Int
}

struct DeathTimeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.timeUntilYear)")
    }
}

@main
struct DeathTimeWidget: Widget {
    let kind: String = "DeathTimeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeathTimeWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Time Until Death")
        .description("Get a live updated count down of your remaining life.")
    }
}

struct DeathTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        DeathTimeWidgetEntryView(entry: SimpleEntry(date: Date(), timeUntilYear: 1892160000))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
