//
//  ContentView.swift
//  Mortgage-Calculator
//
//  Created by Kurt De Jonghe on 20/12/2022.
//

import SwiftUI

struct ContentView: View {
    @State var showmonthlyPaymentCard: Bool = false // shows payment card when button is pushed
    @State var showHousIcon: Bool = true // hide's house image when button is pushed
    
    // main variables
    @State private var myPrincipal = ""
    @State private var myInterestRate = ""
    @State private var myTerms = ""
    
    // calculation variables
    @State private var monthlyPayment = ""
//    @State private var isVisible : Bool = false
    
    
    // Let's keyboard disapear when button is pressed
    private enum Field: Double {
        case myPrincipal, myInterestRate, myTerms
    }
    @FocusState private var focusedField: Field?
    
    // MARK: Calculations
    private func caclulateMortgage() {
        
        var numberOfMonthlyPayments : Double {
            guard let m = Double(myTerms),
                  let n = Optional(12.00) else { return 0 }
            
            return m * n
        }
        
        var percentageCalculation : Double {
            guard let m = Double(myInterestRate),
                  let n = Optional(100.00),
                  let o = Optional(12.00) else { return 0 }
            
            return m / n / o
            
        }
        
        var monthlyPaymentAmount : Double {
            guard let principal = Double(myPrincipal),
                  let rate = Optional(percentageCalculation),
                  let numPayments = Optional(numberOfMonthlyPayments) else { return 0}
            
            return (rate * principal * (pow(1 + rate, numPayments))) / ((pow(1 + rate, numPayments)) - 1)
        }
        
        let netMonthlyPayment = String(format: "%.2f", monthlyPaymentAmount)
        monthlyPayment = "Te betalen: \(netMonthlyPayment) €"
        
        
    }
    // MARK: Main view
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .center) {
                    Text("Hypotheek Calculator")
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    if self.showHousIcon {
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 100))
                                .frame(width: 100, height: 200)
                                .foregroundColor(.yellow)
                        }
                        .zIndex(1)
                    }
                    
                    // MARK: Payment Card
                    if self.showmonthlyPaymentCard {
                        VStack {
                            Text("Maandelijkse aflossing")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(monthlyPayment)")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                        .frame(width: 300, height: 50)
                        .padding(30)
                        .background(Color.black)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                        .zIndex(1)
                    }
                }
                
                // MARK: Input Card
                VStack {
                    VStack {
                        HStack {
                            Text("Leen bedrag (€)")
                                .frame(width: 200, alignment: .leading)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(10)
                            TextField("0.00", text: $myPrincipal)
                                .focused($focusedField, equals: .myPrincipal)
                                .frame(width: 70)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        HStack {
                            Text("Rentevoet (jkp %)")
                                .frame(width: 200, alignment: .leading)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(10)
                            TextField("0", text: $myInterestRate)
                                .focused($focusedField, equals: .myInterestRate)
                                .frame(width: 70)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        HStack {
                            Text("Looptijd lening (Jaar)")
                                .frame(width: 200, alignment: .leading)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(10)
                            
                            TextField("0", text: $myTerms)
                                .focused($focusedField, equals: .myTerms)
                                .frame(width: 70)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        HStack {
                            Button {
                                caclulateMortgage()
                                focusedField = nil
                                
                                withAnimation {
                                    self.showmonthlyPaymentCard.toggle()
                                    self.showHousIcon.toggle()
                                }
                                
//                                self.showmonthlyPaymentCard = true
//                                self.showHousIcon = false
                            } label: {
                                Label("BEREKEN BEDRAG", systemImage: "eurosign")
                            }
                            .tint(.yellow)
                            .buttonStyle(.bordered)
                            .padding(.top, 25)
                        }
                    }
                    .frame(width: 300, height: 200)
                    .padding(30)
                    .background(Color.black)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    
                    // output card
                }
//                .KeyboardResponsive() // This makes pushes up the view when keyboard apears
                
                Spacer()
                
                // MARK: footer
                VStack {
                    Text("®Created by KDJ")
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                }
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro Max")
    }
}

