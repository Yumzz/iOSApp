//
//  YumzzSurvey.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 9/17/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


typealias MCQ = MultipleChoiceQuestion
typealias MCR = MultipleChoiceResponse



func ImportanceQuestion( _ title : String ) -> MultipleChoiceQuestion {
    return MultipleChoiceQuestion(title: title, answers: [ "Not At All" , "Somewhat", "Very" ], tag: TitleToTag(title))
}

let SampleSurvey = Survey([
    
    MCQ(title: "How important is seeing your food before ordering it in a restaurant?",
                                          items: [
                                            "Very Important",
                                            "Somewhat important",
                                            "Not important at all",
                                          ], multiSelect: false,
                                          tag: "rate-importance"),
    
    
//    InlineMultipleChoiceQuestionGroup(title: "How important is seeing your food before ordering it in a restaurant?",
//                                      questions: [
//                                        ImportanceQuestion("Very Important"),
//                                        ImportanceQuestion("Helpful but not important"),
//                                        ImportanceQuestion("Not important at all"),
//                                      ],
//                                      tag: "importance-what-improvements"),
    
    MCQ(title: "On a scale of 1-10, how likely are you to recommend this 3D experience to a friend or family?",
                                          items: [
                                            "1",
                                            "2",
                                            "3",
                                            "4",
                                            "5",
                                            "6",
                                            "7",
                                            "8",
                                            "9",
                                            "10",
                                          ], multiSelect: false,
                                          tag: "rate-experience"),
    
//    going_In,
//
//    callWaiter,
//
//    dishRec,
//
//    cuisine_form,
    
    contact_form
    
//    ask_comments,
//
//    comments_form.setVisibleWhenSelected(ask_comments.choices.first!),
    
    
],
version: "001")

let callWaiter =
    BinaryQuestion(title: "Would you like to be able to call a waiter from your table?" , answers: ["Yes", "No"],
                    tag: "call-waiter")

let dishRec =  BinaryQuestion(title: "Would you like to be able to get a dish recommendation based on your tastes next time you order?" , answers: ["Yes", "No"],
                              tag: "dish-rec")

let going_In =
    BinaryQuestion(title: "Are you interested in going to Casa Azteca after this experience?" , answers: ["Yes", "No"],
                    tag: "going-in")

let contact_form = ContactFormQuestion(title: "Please share your contact info to ensure first time experience", tag: "contact-form")



// Some
let ask_comments =
    BinaryQuestion(title: "Do you have any feedback or feature ideas for us - anything that would enhance your experience at restaurants?",
                   answers: ["Yes", "No"],
                   autoAdvanceOnChoice: true,
                   tag: "do-you-have-feedback")

let comments_form = CommentsFormQuestion(title: "Tell us your ideas or feature requests with AR, i.e. a take home experience of these AR models to show friends and hold rewards.",
                                         subtitle: "Optionally leave your email",
                                         tag: "feedback-comments-form")

let cuisine_form = CommentsFormQuestion(title: "When going out, what type of cuisine do you eat most often?", subtitle: "Like Mexican or Indian", tag: "type-cuisine")


struct SampleSurvey_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SurveyView(survey: SampleSurvey).preferredColorScheme(.light)
        
    }
}
