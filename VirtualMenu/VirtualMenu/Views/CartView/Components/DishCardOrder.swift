
import SwiftUI

struct DishCardOrder: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    var count: Int
    var name: String
    var price: Double
        
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 20) {
                Spacer().frame(width: 5, height: 0)

                VStack{
                    Rectangle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(#colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)))
                        .cornerRadius(10)
                        .overlay(Text("\(count)"))
                }
                
                
                Spacer()
                    .frame(maxWidth: 0)
//
                VStack {
                    Text(name).bold()
                        .foregroundColor(Color.primary)
                        .font(.system(size: 18))

                }
                
                Spacer()
//
                VStack {
                    Text("$\(price.removeZerosFromEnd())")
                        .foregroundColor(Color.primary)
                        .font(.system(size: 18)).bold()
                    }
//                .frame(height: 70)
//                .padding(.leading, 5)
//
                Spacer().frame(width: 5, height: 0)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 55)
            .background(Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
}

struct DishCardOrder_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
        }
    }
}
