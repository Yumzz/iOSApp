
import SwiftUI

struct DishCardOrder: View {
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    var count: Int
    var name: String
    @State var price: Double
    
    var dish: DishFB
    let dispatchGroup = DispatchGroup()
    @EnvironmentObject var order : OrderModel

        
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
                        .overlay(Text("\(count)").foregroundColor(.black))
                }
                
                
                Spacer()
                    .frame(maxWidth: 0)
//
                VStack {
                    Text(name).bold()
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                    if(self.order.optsChosen[dish] != nil){
                        ScrollView(.horizontal){
                            HStack(spacing: 2){
                                Text("Added:")
                                    .font(.system(size: 10))
                                ForEach(self.order.optsChosen[dish]!, id: \.self){ option in
                                    if(option == self.order.optsChosen[dish]?.last){
                                        Text(option)
                                            .foregroundColor(.black)
                                            .font(.system(size: 10))
                                    }
                                    else{
                                        Text("\(option),")
                                            .foregroundColor(.black)
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                Spacer()
//
                VStack {
                    Text("$\(price.removeZerosFromEnd())")
                        .foregroundColor(.black)
                        .font(.system(size: 18)).bold()
                    }
                
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
            .background(Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
        .onAppear(){
            if(self.order.optsChosen[dish] != nil){
                for x in self.order.optsChosen[dish]!{
                    self.price += Double(dish.options[x]!)
                }
            }
        }
    }
}

//struct DishCardOrder_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", singPrice: true, rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
//        }
//    }
//}
