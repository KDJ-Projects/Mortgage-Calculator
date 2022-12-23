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
    @State var showDetailInfoCard: Bool = false
    
    // main variables
    @State private var myPrincipal = ""
    @State private var myInterestRate = ""
    @State private var myTerms = ""
    
    // calculation variables
    @State private var monthlyPayment = ""
    @State private var monthlyPrincipals = ""
    @State private var monthlyIntrest = ""
    
    // let's keyboard disapear when button is pressed
    private enum Field: Double {
        case myPrincipal, myInterestRate, myTerms
    }
    @FocusState private var focusedField: Field?
    
    // caculation section
    private func caclulateMortgage() {
        
        // monthly card payment calculations
        var numberOfMonthlyPayments : Double {
            guard let m = Double(myTerms),
                  let n = Optional(12.00) else { return 0 }
            
            return m * n
        }
        
        var monthPercentage : Double {
            guard let m = Double(myInterestRate),
                  let n = Optional(100.00),
                  let o = Optional(12.00) else { return 0 }
            
            return m / n / o
            
        }
        
        var monthlyPaymentAmount : Double {
            guard let principal = Double(myPrincipal),
                  let rate = Optional(monthPercentage),
                  let numPayments = Optional(numberOfMonthlyPayments) else { return 0}
            
            return (rate * principal * (pow(1 + rate, numPayments))) / ((pow(1 + rate, numPayments)) - 1)
        }
        
        let netMonthlyPayment = String(format: "%.2f", monthlyPaymentAmount)
        monthlyPayment = "Te betalen: \(netMonthlyPayment) €"
        
        // detail card payment calculations
        var netMonthlyPrincipal : Double {
            guard let principal = Double(myPrincipal),
                  let numPeriods = Optional(numberOfMonthlyPayments) else { return 0 }
            
            return principal / numPeriods
        }
        let netPrincipals = String(format: "%.2f", netMonthlyPrincipal)
        monthlyPrincipals = "Basis maand aflossing: \(netPrincipals) €"
        
        var netMonthlyPercentage : Double {
            guard let basePayment = Optional(monthlyPaymentAmount),
                  let basePrincipal = Optional(netMonthlyPrincipal) else { return 0 }
            
            return basePayment - basePrincipal
        }
        let netBase = String(format: "%.2f", netMonthlyPercentage)
        monthlyIntrest = "Maandelijkse intrest: \(netBase) €"
        
    }
    // main view section
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red , .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .center) {
                    
                    // title of the app
                    Text("Hypotheek Calculator")
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    // shows the house icon above the view
                    if self.showHousIcon {
                        VStack {
                            HStack(spacing: 70.0) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 100))
                                    .frame(width: 100, height: 200)
                                    .foregroundColor(.yellow)
                                
                                Image(systemName: "eurosign.square.fill")
                                    .font(.system(size: 100))
                                    .frame(width: 100, height: 200)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .zIndex(1)
                    }
                    
                    // payment info card section
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
                        .padding(.bottom, 20)
                        .zIndex(1)
                    }
                    
                    // detail info card section
                    if self.showDetailInfoCard {
                        VStack {
                            Text("Detail hypotheek lening")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(monthlyPrincipals)")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(monthlyIntrest)")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                        .frame(width: 300, height: 50)
                        .padding(30)
                        .background(Color.black)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding(.bottom, 30)
                        .zIndex(1)
                    }
                }
                
                // input info card section
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
                        
                        // button section
                        HStack {
                            Button {
                                caclulateMortgage()
                                focusedField = nil
                                
                                withAnimation {
                                    self.showmonthlyPaymentCard.toggle()
                                    self.showHousIcon.toggle()
                                    self.showDetailInfoCard.toggle()
                                }
                                
                            } label: {
                                Label("BEREKEN LENING", systemImage: "eurosign")
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
                }
//                .KeyboardResponsive() // pushes the view up when the keyboard apears (KeyBoard.swift)
                
                Spacer()
                
                // footer section
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

