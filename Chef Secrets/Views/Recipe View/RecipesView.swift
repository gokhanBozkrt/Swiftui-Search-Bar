/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct RecipesView: View {
  @Environment(\.isSearching) var isSearching
  @Binding var searchQuery: String
  @Binding var isSearchingIngredient: Bool

  var chefRecipesModel = ChefRecipesModel()

  var filteredRecipes: [Recipe] {
    if searchQuery.isEmpty {
      return chefRecipesModel.recipes
    } else {
      if isSearchingIngredient {
        let filteredRecipes = chefRecipesModel.recipes.filter {
          !$0.ingredients.filter { ingredient in
            ingredient.emoji == searchQuery
          }.isEmpty
        }
        return filteredRecipes
      } else {
        return chefRecipesModel.recipes.filter {
          $0.name.localizedCaseInsensitiveContains(searchQuery)
        }
      }
    }
  }

  var body: some View {
    VStack {
      Toggle("**Search By Ingredients**", isOn:
        $isSearchingIngredient)
          .tint(Color("rw-green"))
          .foregroundColor(Color("rw-green"))
          .font(.body)
          .padding([.leading, .trailing])
      if isSearching {
        Text("""
          Search Results: \(filteredRecipes.count) \
          of \(chefRecipesModel.recipes.count)
          """)
          .foregroundColor(Color("rw-green"))
          .opacity(0.5)
      }
      List {
        ForEach(filteredRecipes, id: \.self) { recipe in
          NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            Text(recipe.name)
              .foregroundColor(Color("rw-dark"))
          }
        }
      }
      .listStyle(.inset)
      .padding()
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Recipes")
          .foregroundColor(Color("rw-dark"))
          .font(.largeTitle)
          .padding()
      }
    }
  }
}

struct RecipesView_Previews: PreviewProvider {
  static var recipes = ChefRecipesModel().recipes

  static var previews: some View {
    RecipesView(
      searchQuery: .constant(""),
      isSearchingIngredient: .constant(false))
        .previewDevice("iPhone SE (2nd generation)")

    RecipesView(
      searchQuery: .constant(""),
      isSearchingIngredient: .constant(false))
        .previewDevice("iPad Pro (12.9-inch) (2nd generation)")
  }
}
