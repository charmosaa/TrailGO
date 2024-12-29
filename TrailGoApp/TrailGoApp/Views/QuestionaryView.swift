import SwiftUI

struct QuestionaryView: View {
    @Binding var feedback: TrailFeedback
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Trail Feedback")
                .font(.headline)

            // Start and End Dates
            DatePicker("Start Date", selection: $feedback.startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $feedback.endDate, displayedComponents: .date)

            // Difficulty Picker
            VStack(alignment: .leading) {
                Text("Difficulty")
                Picker("Difficulty", selection: $feedback.difficulty) {
                    ForEach(1...5, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .tint(Color(hex: "#108932") )
            }

            // Grade Picker
            VStack(alignment: .leading) {
                Text("Experience")
                Picker("Experience", selection: $feedback.grade) {
                    ForEach(1...5, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .tint(Color(hex: "#108932") )
            }

            // Comment Field
            VStack(alignment: .leading) {
                Text("Comment")
                TextField("Write your comment here...", text: $feedback.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Buttons
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button("Save") {
                    onSave()
                }
                .padding()
                .background(Color(hex: "#108932") )
                .foregroundColor(.white)
                .cornerRadius(10)
                
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 400)
    }
}
