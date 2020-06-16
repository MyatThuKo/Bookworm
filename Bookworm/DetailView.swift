//
//  DetailView.swift
//  Bookworm
//
//  Created by Myat Thu Ko on 6/15/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import CoreData
import SwiftUI

struct DetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var formattedDate: String {
        if let date = self.book.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No Review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                    .padding()
                
                Text("Added Date: \(self.formattedDate)")
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(self.book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")){
                self.deleteBook()
                }, secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert.toggle()
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)
        
        try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Test Review"
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
