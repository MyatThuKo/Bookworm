//
//  AddBookView.swift
//  Bookworm
//
//  Created by Myat Thu Ko on 6/14/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var date = Date()
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller",
                  "Self-help"]
    
    let ratings = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    
                    TextField("Write a review", text: $review)
                    
                    DatePicker("Today's Date: ", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        guard !self.genre.isEmpty else {
                            self.showAlert.toggle()
                            return
                        }
                        
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = self.date
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Book")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid"), message: Text("Please select the genre."), dismissButton: .default(Text("Okay")))
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
