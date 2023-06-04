import Foundation

struct HourlyChart: Identifiable {
    var id = UUID()
    var hour: String
    var temp: Int

    init(hour: String, temp: Int) {
        self.hour = ""
        self.temp = temp

        self.hour = formatHour(dateString: hour)
    }
    
    func formatHour(dateString: String) -> String {
        let newFormatter = ISO8601DateFormatter()
        let date = newFormatter.date(from: dateString) ?? Date()

        let dateFormatter = DateFormatter()
        
        // e.g. 4pm
        dateFormatter.dateFormat = "ha"
        
        return dateFormatter.string(from: date).lowercased()
    }
}
