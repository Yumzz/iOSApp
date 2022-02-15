
import SwiftUI

struct BuildCardOrder: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    var count: Int
    var name: String
    @State var price: Double
    @State var possPriceIncrease: Bool = false
    
    var build: BuildFB
    let dispatchGroup = DispatchGroup()
    @EnvironmentObject var order : OrderModel
    

    var body: some View {
        ZStack{
            VStack{
                Group {
                    HStack(alignment: .center, spacing: 10) {
                        Spacer().frame(width: 5, height: 0)

//                        VStack{
//                            Rectangle()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(Color(#colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)))
//                                .cornerRadius(10)
//                                .overlay(Text("\(count)").foregroundColor(.black))
//                        }
                        (Text("\(count)").foregroundColor(Color("Blackest")))
                            .font(.system(size: 14))
//                        Spacer()
//                            .frame(maxWidth: 0)
        //
                        VStack {
                            ScrollView(.horizontal){
                                Text(name).bold()
                                    .foregroundColor(Color("Blackest"))
                                    .font(.system(size: 14))
                            }
                        }
//                        .scaledToFit()
                        Spacer()
        //
                        if(String(self.price).components(separatedBy: ".")[1].count < 2){
                            if(String(self.price).components(separatedBy: ".")[1].count < 1){
                                Text(String(self.price) + "00" + (possPriceIncrease ? "+" : "")).foregroundColor(Color("Blackest"))
                                    .font(.system(size: 14)).bold()
                                Spacer()
                            }
                            else{
                                Text(String(self.price) + "0" + (possPriceIncrease ? "+" : "")).foregroundColor(Color("Blackest"))
                                    .font(.system(size: 14)).bold()
                                Spacer()
                            }
                        }
                        else{
                            Text(String(self.price) + (possPriceIncrease ? "+" : ""))
                                .foregroundColor(Color("Blackest"))
                                .font(.system(size: 14)).bold()
                            Spacer()
                        }
//                        VStack {
//                            Text("$\(price.removeZerosFromEnd())")
//                                .foregroundColor(.black)
//                                .font(.system(size: 18)).bold()
//                            }
                        
                        Spacer()
        //                .frame(height: 70)
        //                .padding(.leading, 5)

        //

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 55)
                    .background(Color("DarkestWhite"))
                    .cornerRadius(10)
                    .shadow(radius: 2)
//                    .scaledToFit()
                }
//                .scaledToFit()
                .padding(.horizontal)
                .onAppear(){
//                    if(dish.description.co)
                    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "IncrPriceNotPoss"), object: nil, queue: .main) { [self] (Notification) in
                        possPriceIncrease = false
                    }
                    var numSet = CharacterSet()
                    numSet.insert(charactersIn: "0123456789")
                    if(build.description.rangeOfCharacter(from: numSet) != nil){
                            possPriceIncrease = true
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PricePossIncrease"), object: nil)
                    }
                    
                    if(self.order.buildOptsChosen[build] != nil){
                        for x in self.order.buildOptsChosen[build]!{
                            print("yes: \(x)")
                            //need to get keys of x in add ons and put in individualcosts
                            if build.individCost{
                                for k in build.addOns.keys {
                                    if(build.addOns[k]!.contains(x)){
                                        let ind = build.addOns[k]!.firstIndex(of: x)
                                        print("yess: \(build.individualCosts[k]![ind!])")
                                        self.price += Double((build.individualCosts[k]![ind!] as! NSString) as Substring)!
                                    }
                                }
                            }
//                            if let key = build.addOns.someKey(forValue: x) {
//                                print(key)
//                                self.price += Double((build.individualCosts[key]! as! NSString) as Substring)!
//                            }
                        }
                    }
                }
                
            }
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .frame(height: 55)
//        .background(ColorManager.textGray)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//        .scaledToFit()
    }
}

//struct DishCardOrder_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", singPrice: true, rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
//        }
//    }
//}
