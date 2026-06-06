require_relative 'inventory'

DB_FILE = 'books.csv'

# Helper to read non-empty input from console
def prompt_input(prompt_text, error_message = "Input cannot be empty. Please try again.")
  loop do
    print "#{prompt_text}: "
    input = gets.chomp.strip
    return input unless input.empty?
    
    puts "\n[Error] #{error_message}\n\n"
  end
end

# Renders a formatted table of books
def display_books_table(books)
  if books.empty?
    puts "\nNo books found in the inventory.\n"
    return
  end

  # Calculate column widths dynamically to prevent overflow
  isbn_width   = [books.map { |b| b.isbn.length }.max, 10].max
  title_width  = [books.map { |b| b.title.length }.max, 20].max
  author_width = [books.map { |b| b.author.length }.max, 20].max
  qty_width    = [books.map { |b| b.quantity.to_s.length }.max, 8].max

  # Print Table Header
  separator = "+-#{'-' * isbn_width}-+-#{'-' * title_width}-+-#{'-' * author_width}-+-#{'-' * qty_width}-+"
  puts separator
  puts "| %-#{isbn_width}s | %-#{title_width}s | %-#{author_width}s | %-#{qty_width}s |" % ['ISBN', 'Title', 'Author', 'Quantity']
  puts separator

  # Print Table Rows
  books.each do |book|
    puts "| %-#{isbn_width}s | %-#{title_width}s | %-#{author_width}s | %#{qty_width}d |" % [
      book.isbn, book.title, book.author, book.quantity
    ]
  end
  puts separator
  puts "Total unique books: #{books.size}"
  puts "Total book quantity: #{books.sum(&:quantity)}"
end

def main
  # Initialize the inventory
  inventory = Inventory.new(DB_FILE)

  loop do
    puts "\n"
    puts "=================================================="
    puts "            Book Inventory System"
    puts "=================================================="
    puts " 1. List all books (sorted by ISBN)"
    puts " 2. Add a new book"
    puts " 3. Remove a book (by ISBN)"
    puts " 4. Search books"
    puts " 5. Exit"
    puts "=================================================="
    print "Please choose an option (1-5): "
    
    choice = gets.chomp.strip

    case choice
    when '1'
      puts "\n--- List of Books (Sorted by ISBN) ---"
      display_books_table(inventory.list_books)

    when '2'
      puts "\n--- Add a New Book ---"
      isbn = prompt_input("Enter ISBN")
      title = prompt_input("Enter Title")
      author = prompt_input("Enter Author")

      status, result = inventory.add_book(isbn, title, author)
      
      case status
      when :added
        puts "\n[Success] Book '#{result.title}' (ISBN: #{result.isbn}) added successfully!"
      when :updated
        puts "\n[Success] Book (ISBN: #{result.isbn}) updated! Count increased to #{result.quantity}."
        puts "Current Title: '#{result.title}', Author: '#{result.author}'."
      when :invalid
        puts "\n[Error] #{result}"
      end

    when '3'
      puts "\n--- Remove a Book ---"
      isbn = prompt_input("Enter ISBN to remove")
      status, result = inventory.remove_book(isbn)

      case status
      when :removed
        puts "\n[Success] Book '#{result.title}' (ISBN: #{result.isbn}) was completely removed from inventory."
      when :decremented
        puts "\n[Success] Quantity of book '#{result.title}' (ISBN: #{result.isbn}) decremented. New quantity: #{result.quantity}."
      when :not_found
        puts "\n[Error] #{result}"
      end

    when '4'
      puts "\n--- Search Books ---"
      puts "Search by:"
      puts " 1. Title"
      puts " 2. Author"
      puts " 3. ISBN"
      print "Choose search field (1-3): "
      search_choice = gets.chomp.strip

      field = case search_choice
              when '1' then :title
              when '2' then :author
              when '3' then :isbn
              else
                puts "\n[Error] Invalid choice. Returning to main menu."
                next
              end

      query = prompt_input("Enter search term")
      results = inventory.search_books(query, field)

      puts "\n--- Search Results ---"
      display_books_table(results)

    when '5'
      puts "\nThank you for using the Book Inventory System. Goodbye!\n\n"
      break

    else
      puts "\n[Error] Invalid option. Please enter a number between 1 and 5."
    end
  end
end

# Run the program
main if __FILE__ == $0
