# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# require "net/http"
# require "csv"

require 'json'

# #url = 'https://gutendex.com/books/?languages=en&sort=downloads'
# uri = URI(url)

# response = Net::HTTP.get_response(uri)
# if response.is_a?(Net::HTTPSuccess)
#    result = JSON.parse(response.body)["results"]
#    File.open('books.csv', 'w')
#    ActiveRecord::Base.transaction do
#      result.each do |element|
#        attributes = element.deep_symbolize_keys.slice(:id, :title, :summaries, :authors, :subjects, :bookshelves)
#        author = Author.find_or_create_by!(name: attributes[:authors].first[:name])

#        book = Book.find_or_create_by!(title: attributes[:title], author: author, description: attributes[:summaries])
#        categories = attributes[:bookshelves].map { |bookshelf| bookshelf }
#        categories.each do |category|
#          debugger
#          category.delete_prefix!("Category:")
#          book_category = Category.find_or_create_by!(name: category)
#          book.categories << book_category
#        end
#      end
#    end

#    CSV.open("books.csv", "w") do |csv|
#      csv << ["id", "title", "author", "description"]
#      Book.find_each do |book|
#        csv << [book.id, book.title, book.author.name, book.description]
#      end
#    end
# else
#    puts response.code
# end

# json = JSON.load_file('db/data/book_embeddings.json')
# json.each do |book_json|

#   book = Book.find_by(title: book_json["title"])
#   puts book.title + ': '  + book.author.name

#   book.update!(embedding: book_json["embedding"])
# end

json = JSON.load_file('db/data/book_search_text.json')
json.each do |element|
  puts element["heading"]
end

puts "Done!"
