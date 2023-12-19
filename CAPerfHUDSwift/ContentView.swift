// bomberfish
// ContentView.swift – CAPerfHudSwift
// created on 2023-12-18

import SwiftUI
import QuartzCore

struct ContentView: View {
    @State var currentLevel: Int32 = CADebugCommon.getPerfHUDLevel()
    var body: some View {
        NavigationView {
            List {
                ForEach(CADebugCommon.perfHUDLevelNames, id: \.self) { lvl in
                    Button(action: {
                        withAnimation(.snappy) {
                            CADebugCommon.setPerfHUDLevel(Int32(CADebugCommon.perfHUDLevelNames.firstIndex(of: lvl)!))
                            currentLevel = CADebugCommon.getPerfHUDLevel()
                            UISelectionFeedbackGenerator().selectionChanged()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: currentLevel == Int32(CADebugCommon.perfHUDLevelNames.firstIndex(of: lvl)!) ? "checkmark.circle.fill" : "circle") // jank level 1000
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text(lvl)
                                .foregroundColor(Color(UIColor.label))
                        }
                    })
                }
//                Text("\(currentLevel)")
            }
            .navigationTitle("CAPerfHudSwift")
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
