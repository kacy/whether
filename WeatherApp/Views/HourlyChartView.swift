import SwiftUI
import Charts
struct HourlyChartView: View {
    var hourlyCharts: [HourlyChart]
    private var yAxisMinMax: (Double, Double) {
        let minValue = hourlyCharts.map { Double($0.temp) }.min() ?? 0
        let maxValue = hourlyCharts.map { Double($0.temp) }.max() ?? 0
        return (minValue, maxValue)
    }
    
    private func yAxisLabel(for revenue: Double) -> String {
        if revenue == 0.0 {
            // Do not show the "0" label on the Y axis
            return ""
        } else {
            return String(Int(revenue))
        }
    }
    
    private func xAxisLabel(for hour: String) -> String {
        return hour
    }
    
    var body: some View {
        HStack {
            ScrollView {
                Chart {
                    ForEach(hourlyCharts) { hour in
                        LineMark(
                            x: .value("hour", hour.hour),
                            y: .value("temp", hour.temp)
                        )
    //                    .symbol("location.fill")
    //                    .interpolationMethod(.stepStart)
    //                    .interpolationMethod(.stepStart)
                        .interpolationMethod(.linear)
                    }
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                }
                .foregroundColor(Color.orange)
                .chartYScale(domain: (yAxisMinMax.0)...(yAxisMinMax.1))
                .chartXAxis {
//                    AxisMarks(position: .leading, values: .automatic(minimumStride: 10, roundLowerBound: true, roundUpperBound: true)) { value in
                    AxisMarks(values: .automatic(minimumStride: 10, roundLowerBound: true, roundUpperBound: true)) { value in
                        AxisTick()
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.0))
                        AxisValueLabel(xAxisLabel(for: value.as(String.self) ?? ""))
                    }
                }
                .chartYAxis {
    //                AxisMarks(position: .leading, values: .stride(by: yAxisStride)) { value in
                    AxisMarks(position: .leading, values: .automatic(minimumStride: 10, roundLowerBound: true, roundUpperBound: true)) { value in
//                        AxisGridLine()
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.0))
//                        AxisValueLabel(yAxisLabel(for: value.as(Double.self) ?? 0))
                    }
                }
            }
        }
    }
    
    init(hourlyCharts: [HourlyChart]) {
        self.hourlyCharts = hourlyCharts
    }
}
