import SwiftUI

struct AlertsView: View {
    let userID: Int
    @Binding var alerts: [Alert]

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                // Title
                Text("Alerts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)

                if alerts.isEmpty {
                    Text("No alerts available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(alerts, id: \.alertID) { alert in
                                HStack {
                                    Text(alert.message)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .padding()
                                    Spacer()
                                }
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Alerts")
    }
}
