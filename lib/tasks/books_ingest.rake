require "uri"
require "net/http"

namespace :books do
  desc "Downloads books from Gutendex (Project Gutenberg mirror)"
  task :ingest_gutenberg do
    all_books = []

      # 3.times do |i|
      url = URI("https://project-gutenberg-free-books-api1.p.rapidapi.com/books?page_size=100&languages=en")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = "f57e8e96d1mshbe3a5c6abf0f8b9p19705ajsn12cfa13fa097"
      request["x-rapidapi-host"] = "project-gutenberg-free-books-api1.p.rapidapi.com"
      request["Content-Type"] = "application/json"

      response = http.request(request)
      unless response.is_a?(Net::HTTPSuccess)
        warn "Failed page #{i}: #{response.code}"
        # next
      end
      data = JSON.parse(response.read_body)
      books = data["results"] || []
      # break if books.empty?

      all_books.concat(books)
      puts "Fetched #{books.size} books (total: #{all_books.size})"
      sleep 1
    # end

    File.write("books_data.json", JSON.pretty_generate(all_books))
    puts "Done! Saved #{all_books.size} books to books_data.json"
  end
end





# File.open('books.csv', 'w')
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
