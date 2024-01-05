import Foundation
import SwiftUI

struct LineChartView: View {
    var data: [NSDecimalNumber]
    
    // Convert NSDecimalNumber array to Double array
    var doubleData: [Double] {
        data.compactMap { $0.doubleValue }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let dataMax = self.doubleData.max() ?? 0.0
            let dataMin = self.doubleData.min() ?? 0.0
            
            let verticalDataRange = dataMax - dataMin
            let horizontalDataRange = Double(self.data.count - 1)
            
            // Draw the line chart
            Path { path in
                for i in 0..<self.data.count {
                    let x = (Double(i) / horizontalDataRange) * Double(width)
                    let y = (1.0 - ((self.doubleData[i] - dataMin) / verticalDataRange)) * Double(height)
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue)
            
            // Draw the X axis
            Path { path in
                let yAxisPosition = (1.0 - ((0 - dataMin) / verticalDataRange)) * Double(height)
                path.move(to: CGPoint(x: 0, y: yAxisPosition))
                path.addLine(to: CGPoint(x: width, y: yAxisPosition))
            }
            .stroke(Color.gray, lineWidth: 1)
        }
    }
}
