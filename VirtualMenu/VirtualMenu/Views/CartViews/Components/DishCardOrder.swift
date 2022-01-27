
import SwiftUI

struct DishCardOrder: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    var count: Int
    var name: String
    @State var price: Double
    @State var possPriceIncrease: Bool = false
    
    var dish: DishFB
    var dark: Bool = false
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
                        (Text("\(count)").foregroundColor(dark ? .white : .black))
                            .font(.system(size: 14))
//                        Spacer()
//                            .frame(maxWidth: 0)
        //
                        VStack {
                            ScrollView(.horizontal){
                                Text(name).bold()
                                    .foregroundColor(dark ? .white : .black)
                                    .font(.system(size: 14))
                            }
                        }
//                        .scaledToFit()
                        Spacer()
        //
                        if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                            if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                                Text(String(dish.price) + "00" + (possPriceIncrease ? "+" : "")).foregroundColor(dark ? .white : .black)
                                    .font(.system(size: 14)).bold()
                                Spacer()
                            }
                            else{
                                Text(String(dish.price) + "0" + (possPriceIncrease ? "+" : "")).foregroundColor(dark ? .white : .black)
                                    .font(.system(size: 14)).bold()
                                Spacer()
                            }
                        }
                        else{
                            Text(String(dish.price) + (possPriceIncrease ? "+" : ""))
                                .foregroundColor(dark ? .white : .black)
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
                        
        //                VStack {
        //                    XButtonDelete()
        //                        .onTapGesture {
        //                            self.dispatchGroup.enter()
        //                            self.order.deleteDish(dish: self.dish, dis: self.dispatchGroup)
        //                            self.dispatchGroup.notify(queue: .main){
        //
        //                            }
        //                        }
        //                    }
        //

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 55)
                    .background(dark ? ColorManager.blackest : Color(.white))
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
                    if(dish.description.rangeOfCharacter(from: numSet) != nil){
                            possPriceIncrease = true
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PricePossIncrease"), object: nil)
                    }
                    if(self.order.optsChosen[dish] != nil){
                        for x in self.order.optsChosen[dish]!{
                            self.price += Double(dish.options[x]!)
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
