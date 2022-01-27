
import SwiftUI

struct ReceiptCard: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
//    var count: Int
//    var name: String
    @State var pricePossIncrease: Bool = false
    var total: Double
    var dark: Bool = false
    
    var tax = 5.00
        
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    Spacer().frame(width: 5, height: 0)
                    Text("Subtotal")
                        .font(.system(size: 14)).bold().foregroundColor(dark ? .white : .black)
//                        .overlay(Text("\(count)"))
//                    Spacer().frame(width: UIScreen.main.bounds.size.width/2, height: 0)
                    Spacer()
                    Text("\(DishFB.priceFix(price: String(total)))" + (pricePossIncrease ? "+" : "")).foregroundColor(dark ? .white : .black)
                    Spacer().frame(width: 5, height: 0)
                }
                
                HStack{
                    Spacer().frame(width: 5, height: 0)
                    Text("Tax & Fees")
                        .font(.system(size: 14)).bold().foregroundColor(dark ? .white : .black)
//                        .overlay(Text("\(count)"))
//                    Spacer().frame(width: UIScreen.main.bounds.size.width/2, height: 0)
                    Spacer()
                    Text("\(DishFB.priceFix(price: String(tax)))").foregroundColor(dark ? .white : .black)
                    Spacer().frame(width: (pricePossIncrease ? 15 : 5), height: 0)
                }
                
                Divider().frame(width: (UIScreen.main.bounds.width/1.2), height: 10, alignment: .leading)
                    .foregroundColor(dark ? .white : Color.black)
                
                HStack{
                    Spacer().frame(width: 5, height: 0)
                    Text("Total")
                        .font(.system(size: 14)).bold().foregroundColor(dark ? .white : .black)
//                        .overlay(Text("\(count)"))
                    Spacer()
//                    Spacer().frame(width: UIScreen.main.bounds.size.width/1.7, height: 0)
                    Text("\(DishFB.priceFix(price: String(tax + total)))" + (pricePossIncrease ? "+" : "")).foregroundColor(dark ? .white : .black)
                    Spacer().frame(width: 5, height: 0)


                }
                
            }
//                VStack{
//                    Rectangle()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(Color(#colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)))
//                        .cornerRadius(10)
//                        .overlay(Text("\(count)"))
//                }
//
//
//                Spacer()
//                    .frame(maxWidth: 0)
////
//                VStack {
//                    Text(name).bold()
//                        .foregroundColor(Color.primary)
//                        .font(.system(size: 18))
//
//                }
//
//                Spacer()
////
//                VStack {
//                    Text("\(price.removeZerosFromEnd())")
//                        .foregroundColor(ColorManager.textGray)
//                        .font(.system(size: 18))
//                    }
//                .frame(height: 70)
//                .padding(.leading, 5)
////
//            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 120)
            .background(dark ? ColorManager.blackest : Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
            .onAppear(){
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PricePossIncrease"), object: nil, queue: .main) { [self] (Notification) in
                    self.pricePossIncrease = true
                }
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "IncrPriceNotPoss"), object: nil, queue: .main) { [self] (Notification) in
                    self.pricePossIncrease = false
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ReceiptCard_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
//            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
        }
    }
}
