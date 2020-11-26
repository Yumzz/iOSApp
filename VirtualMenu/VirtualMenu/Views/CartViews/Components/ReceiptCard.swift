
import SwiftUI

struct ReceiptCard: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
//    var count: Int
//    var name: String
    var total: Double
    
    var tax = 5.00
        
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 2) {
                HStack{
                    Text("Subtotal")
                        .font(.system(size: 14)).bold()
//                        .overlay(Text("\(count)"))
                    Spacer().frame(width: UIScreen.main.bounds.size.width/2, height: 0)
                    Text("\(DishFB.formatPrice(price: total))")
                }
                
                HStack{
                    Text("Tax & Fees")
                        .font(.system(size: 14)).bold()
//                        .overlay(Text("\(count)"))
                    Spacer().frame(width: UIScreen.main.bounds.size.width/2, height: 0)
                    Text("\(DishFB.formatPrice(price: tax))")

                }
                
                Divider().frame(width: (UIScreen.main.bounds.width/1.2), height: 10, alignment: .leading)
                    .foregroundColor(Color.black)
                
                HStack{
                    Text("Total")
                        .font(.system(size: 14)).bold()
//                        .overlay(Text("\(count)"))
                    Spacer().frame(width: UIScreen.main.bounds.size.width/1.7, height: 0)
                    Text("\(DishFB.formatPrice(price: tax + total))")

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
            .background(Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
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
