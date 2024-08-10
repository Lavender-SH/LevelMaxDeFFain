import SwiftUI

struct MenuListView: View {
    @EnvironmentObject var caffeineModel: SharedDataModel
    @EnvironmentObject var sharedData: SharedDataModel
    
    @State private var selectedCategory: BeverageCategory? = nil
    @State private var selectedMenu = beverages
    @State private var showSheet = false
    @State private var tappedMenu: Beverage = beverages[0]

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        var backButton : some View {
            Button{
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.my581919)
                    Text("Back")
                        .foregroundColor(.my581919)
                }
            }
        }

    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Label(
                            title: { Text("Find")
                                .font(.system(size: 17, weight: .semibold))},
                            icon: { Image(systemName: "magnifyingglass") }
                        )
                        .foregroundColor(Color(red: 0.35, green: 0.1, blue: 0.1))
                    })
                    .frame(width: 116, height: 32)
                    .background(.white)
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.56, green: 0.56, blue: 0.58), lineWidth: 1)
                    )
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(BeverageCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    // Update selected category and filter beverages
                                    if selectedCategory == category {
                                        selectedCategory = nil // Deselect if the same category is clicked
                                        selectedMenu = beverages // Show all beverages
                                    } else {
                                        selectedCategory = category
                                        selectedMenu = filterBeverages(by: category) // Filter beverages based on the selected category
                                    }
                                }, label: {
                                    Text("\(category.rawValue.capitalized)")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(selectedCategory == category ? Color.white : Color(red: 0.35, green: 0.1, blue: 0.1))
                                })
                                .frame(width: 116, height: 32)
                                .background(selectedCategory == category ? Color(red: 0.35, green: 0.1, blue: 0.1) : .white)
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .inset(by: 0.5)
                                        .stroke(Color(red: 0.56, green: 0.56, blue: 0.58), lineWidth: 1)
                                )
                                .animation(.easeInOut, value: selectedCategory)
                            }
                        }
                        .padding(6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 25)
                
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(selectedMenu) { beverage in
                            
                            Button(action: {
                                showSheet.toggle()
                                tappedMenu = beverage
                                print("\(beverage.name) button tapped!")
                                
                            }) {
                                VStack {
                                    ZStack {
                                        AsyncImage(url: beverage.imageURL) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 110, height: 150)
                                                    .cornerRadius(10)
                                                    .clipped()
                                            case .failure:
                                                Image("Americano")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 110, height: 150)
                                                    .cornerRadius(10)
                                                    .clipped()
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 110, height: 150)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Text("\(beverage.caffeineContent)")
                                                    .font(.system(size: 20, weight: .semibold))
                                                    .multilineTextAlignment(.trailing)
                                                    .foregroundColor(Color(red: 0.35, green: 0.1, blue: 0.1))
                                                    .padding(10)
                                            }
                                        }
                                        
                                    }
                                    Text(beverage.name)
                                        .font(Font.custom("SF Pro", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(height: 50)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding()
                }
                .sheet(isPresented: $showSheet, content: {
                    
                    SheetView(tappedMenu: $tappedMenu, caffeineModel: caffeineModel)
                        .presentationDetents([
                            .height(340)
                        ])
                })
            }
            .background(Color(red: 0.98, green: 0.97, blue: 0.95))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)

    }




    private func filterBeverages(by category: BeverageCategory) -> [Beverage] {
        // Filter beverages based on the selected category
        beverages.filter { $0.bevType == category }
    }
}

#Preview {
    MenuListView()
}


struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedData: SharedDataModel
    @State var value = 2
    @Binding var tappedMenu: Beverage
    @ObservedObject var caffeineModel: SharedDataModel
    @State var caffaine: Int = 0
    @State private var showAlert = false
    var body: some View {
        VStack {
            HStack {
                Text("\(tappedMenu.name)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.bottom, 27)
            HStack {
                VStack {
                    HStack() {
                        Text("Shot")
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                    }
                    HStack() {
                        Text("Basic 2 shots (150mg)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
                        Spacer()
                    }
                }

                Spacer()

                HStack {
                    Button(action: {if value > 0 {
                        value -= 1
                        caffaine -= 75
                    }
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.black)
                    }
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(4)

                    Text("\(value)")
                    Button(action: {
                        value += 1
                        caffaine += 75
                        if caffaine > 200 {
                            showAlert = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                    .frame(width: 28, height: 28)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(4)
                }


            }
            .padding(.bottom, 51)
            Text("Sum: \(caffaine)mg")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color(red: 0.35, green: 0.1, blue: 0.1))

            Button(action: {
                caffeineModel.ingestedCaffeine += caffaine
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Complete")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 19)
                    .padding(.horizontal, 134)
            })
            .background(Color(red: 0.35, green: 0.1, blue: 0.1))
            .cornerRadius(30)

        }
        .padding(.horizontal, 16)
        .alert(isPresented: $showAlert) { // Alert modifier
                    Alert(
                        title: Text("Warning!"),
                        message: Text("Exceed the recommended caffeine intake."),
                        dismissButton: .default(Text("Check"))
                    )
        }
        .onAppear(perform: {
            caffaine = tappedMenu.caffeineContent
            if tappedMenu.bevType != .coffee {
                value = 0
            }
        })
    }
}
