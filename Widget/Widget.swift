import Intents
import SwiftUI
import WidgetKit

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
        }
    }
}

struct SinglePhotoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SinglePhotoEntry {
        SinglePhotoEntry(date: Date(), data: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SinglePhotoEntry) -> ()) {
        let entry = SinglePhotoEntry(date: Date(), data: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SinglePhotoEntry] = []
        let intents = SharedDataStoreManager.shared.getWidgetIntents()
        var usePhotos: [SharedPhoto] = []

        let MAX_PHOTO_NUM = 4

        loop: while true {
            for intent in intents.shuffled() {
                let photo = SharedDataStoreManager.shared.getAsset(id: intent.id)!
                usePhotos.append(photo)

                if usePhotos.count >= MAX_PHOTO_NUM {
                    break loop
                }
            }

            if usePhotos.count >= MAX_PHOTO_NUM {
                break loop
            }
        }

        let currentDate = Date()
        for minOffset in 0 ..< MAX_PHOTO_NUM {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            let entry = SinglePhotoEntry(date: entryDate, data: usePhotos[minOffset], configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SinglePhotoEntry: TimelineEntry {
    let date: Date
    let data: SharedPhoto?
    let configuration: ConfigurationIntent
}

struct SinglePhotoWidgetEntryView: View {
    var entry: SinglePhotoProvider.Entry

    var body: some View {
        if let data = entry.data?.imageData {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
    }
}

struct SinglePhotoWidget: Widget {
    let kind: String = "SinglePhotoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: SinglePhotoProvider()) { entry in
            SinglePhotoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("シングル")
        .description("写真1枚で構成するWidget")
        .supportedFamilies([.systemSmall])
    }
}

struct WidePhotoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidePhotoEntry {
        WidePhotoEntry(date: Date(), data1: nil, data2: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidePhotoEntry) -> ()) {
        let entry = WidePhotoEntry(date: Date(), data1: nil, data2: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidePhotoEntry] = []
        let intents = SharedDataStoreManager.shared.getWidgetIntents()
        var usePhotos: [SharedPhoto] = []

        let MAX_PHOTO_NUM = 4

        loop: while true {
            for intent in intents.shuffled() {
                let photo = SharedDataStoreManager.shared.getAsset(id: intent.id)!
                usePhotos.append(photo)

                if usePhotos.count >= MAX_PHOTO_NUM {
                    break loop
                }
            }

            if usePhotos.count >= MAX_PHOTO_NUM {
                break loop
            }
        }

        let chunked = usePhotos.chunked(by: 2)

        let currentDate = Date()
        for minOffset in 0 ..< MAX_PHOTO_NUM / 2 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            let entry = WidePhotoEntry(
                date: entryDate,
                data1: chunked[minOffset][0],
                data2: chunked[minOffset][1],
                configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidePhotoEntry: TimelineEntry {
    let date: Date
    let data1: SharedPhoto?
    let data2: SharedPhoto?
    let configuration: ConfigurationIntent
}

struct WidePhotoWidgetEntryView: View {
    var entry: WidePhotoProvider.Entry

    var body: some View {
        GeometryReader { geo in
            HStack {
                if let data = entry.data1?.imageData {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                        .clipped()
                }
                if let data = entry.data2?.imageData {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                        .clipped()
                }
            }
        }
    }
}

struct WidePhotoWidget: Widget {
    let kind: String = "WidePhotoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: WidePhotoProvider()) { entry in
            WidePhotoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ワイド")
        .description("写真2枚で構成するWidget")
        .supportedFamilies([.systemMedium])
    }
}

struct LargePhotoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> LargePhotoEntry {
        LargePhotoEntry(
            date: Date(),
            data1: nil,
            data2: nil,
            data3: nil,
            data4: nil,
            configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LargePhotoEntry) -> ()) {
        let entry = LargePhotoEntry(
            date: Date(),
            data1: nil,
            data2: nil,
            data3: nil,
            data4: nil,
            configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [LargePhotoEntry] = []
        let intents = SharedDataStoreManager.shared.getWidgetIntents()
        var usePhotos: [SharedPhoto] = []

        let MAX_PHOTO_NUM = 4

        loop: while true {
            for intent in intents.shuffled() {
                let photo = SharedDataStoreManager.shared.getAsset(id: intent.id)!
                usePhotos.append(photo)

                if usePhotos.count >= MAX_PHOTO_NUM {
                    break loop
                }
            }

            if usePhotos.count >= MAX_PHOTO_NUM {
                break loop
            }
        }

        let currentDate = Date()
        for minOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            let entry = LargePhotoEntry(
                date: entryDate,
                data1: usePhotos[0],
                data2: usePhotos[1],
                data3: usePhotos[2],
                data4: usePhotos[3],
                configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LargePhotoEntry: TimelineEntry {
    let date: Date
    let data1: SharedPhoto?
    let data2: SharedPhoto?
    let data3: SharedPhoto?
    let data4: SharedPhoto?
    let configuration: ConfigurationIntent
}

struct LargePhotoWidgetEntryView: View {
    var entry: LargePhotoProvider.Entry

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                HStack {
                    if let data = entry.data1?.imageData {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                            .clipped()
                    }
                    if let data = entry.data2?.imageData {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                            .clipped()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height / 2, alignment: .center)

                HStack {
                    if let data = entry.data3?.imageData {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                            .clipped()
                    }
                    if let data = entry.data4?.imageData {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 2, height: geo.size.width / 2, alignment: .center)
                            .clipped()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height / 2, alignment: .center)
            }
        }
    }
}

struct LargePhotoWidget: Widget {
    let kind: String = "LargePhotoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LargePhotoProvider()) { entry in
            LargePhotoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ラージ")
        .description("写真4枚で構成するWidget")
        .supportedFamilies([.systemLarge])
    }
}
