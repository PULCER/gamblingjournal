//
//  Animation.swift
//  gamblingjournal
//
//  Created by Anthony Howell on 9/6/23.
//

import SwiftUI

struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.red, Color.yellow, Color.blue, Color.purple, Color.green]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onReceive(timer, perform: { _ in
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.start = UnitPoint(x: 4, y: 0)
                }
            })
    }
}
