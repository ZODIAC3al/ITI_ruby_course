require 'csv'

# Represents a Book entity
class Book
  attr_accessor :isbn, :title, :author, :quantity

  def initialize(isbn, title, author, quantity = 1)
    @isbn = normalize_isbn(isbn)
    @title = title.to_s.strip
    @author = author.to_s.strip
    @quantity = [quantity.to_i, 1].max
  end

  # Validates that required fields are present
  def valid?
    !@isbn.empty? && !@title.empty? && !@author.empty? && @quantity > 0
  end

  private

  def normalize_isbn(isbn_str)
    # Strip whitespace and make it uppercase (important for ISBN-10 'X')
    isbn_str.to_s.strip.upcase
  end
end

# Manages the Collection of Books stored in a CSV file
class Inventory
  attr_reader :books

  def initialize(books_file)
    @books_file = books_file
    @books = {}
    load_books
  end

  # Loads books from the CSV file into the books hash
  def load_books
    @books.clear
    return unless File.exist?(@books_file)

    begin
      CSV.foreach(@books_file, headers: true) do |row|
        isbn = row['ISBN']
        title = row['Title']
        author = row['Author']
        quantity = row['Quantity']

        next if isbn.nil? || title.nil? || author.nil?

        book = Book.new(isbn, title, author, quantity)
        if book.valid?
          if @books[book.isbn]
            @books[book.isbn].quantity += book.quantity
          else
            @books[book.isbn] = book
          end
        end
      end
    rescue CSV::MalformedCSVError => e
      puts "\n[Warning] Database file structure is invalid: #{e.message}"
      puts "A new database will be written upon next change."
    rescue StandardError => e
      puts "\n[Error] Failed to load books: #{e.message}"
    end
  end

  # Saves the current book collection back to the CSV file
  def save_books
    begin
      CSV.open(@books_file, 'wb') do |csv|
        csv << ['ISBN', 'Title', 'Author', 'Quantity']
        @books.values.each do |book|
          csv << [book.isbn, book.title, book.author, book.quantity]
        end
      end
    rescue StandardError => e
      puts "\n[Error] Failed to save books: #{e.message}"
    end
  end

  # Adds a new book or updates an existing one if the ISBN matches
  def add_book(isbn, title, author)
    isbn = isbn.to_s.strip.upcase
    title = title.to_s.strip
    author = author.to_s.strip

    # Validation check
    if isbn.empty? || title.empty? || author.empty?
      return [:invalid, "ISBN, Title, and Author cannot be empty."]
    end

    if @books.key?(isbn)
      book = @books[isbn]
      # Update title and author if they have changed and are not empty
      book.title = title
      book.author = author
      book.quantity += 1
      save_books
      [:updated, book]
    else
      book = Book.new(isbn, title, author, 1)
      @books[isbn] = book
      save_books
      [:added, book]
    end
  end

  # Removes a book by ISBN. Decrements quantity or deletes completely.
  def remove_book(isbn)
    isbn = isbn.to_s.strip.upcase
    return [:not_found, "Book with ISBN '#{isbn}' not found in inventory."] if isbn.empty? || !@books.key?(isbn)

    book = @books[isbn]
    if book.quantity > 1
      book.quantity -= 1
      save_books
      [:decremented, book]
    else
      @books.delete(isbn)
      save_books
      [:removed, book]
    end
  end

  # Lists books sorted by ISBN
  def list_books
    @books.values.sort_by(&:isbn)
  end

  # Searches books by a given query inside a field
  def search_books(query, field)
    query = query.to_s.strip.downcase
    return [] if query.empty?

    @books.values.select do |book|
      case field
      when :title
        book.title.downcase.include?(query)
      when :author
        book.author.downcase.include?(query)
      when :isbn
        book.isbn.downcase.include?(query)
      else
        false
      end
    end
  end
end
