require 'resolv'

def do_something
    yield if block_given?
end

do_something do
  puts "Hello from inside the block"
end

#----

def do_something_with_an_arg
  yield("Hello") if block_given?
end
#We are holding the argument in the method definition.

do_something_with_an_arg do |message|
  puts "The message is #{message}"
end
#When we call the method, with the argument "message",
#yield is holding itself within the method definition.

#----

def print_the_value_returned_by_the_block
  if block_given?
    value = yield
    puts "The block returned #{value}"
  end
end
print_the_value_returned_by_the_block { 3.14159 / 4.0 }

#----

class Document
  def initialize(content)
    @content = content
  end

  def each_character
    index = 0
    while index < @content.size
      yield( @content[index] )
      index += 1
    end
  end

end

d = Document.new("This is a sentence.")
d.each_character {|char| puts char}
#----

#The times method on Ruby integers.
12.times {|x| puts "The number is #{x}"}

#----
Resolv.each_address("www.google.com") {|x| puts x}

#----

# def some_method( doc )
#   big_array = Array.new( 10000000 )
#   # Do something with big_array...
#   doc.on_load do |d|
#     puts "Hey, I've been loaded!"
#   end
# end

# Because the big array was in scope when you created the block
# and the block drags along the local environment with it,
# the block holds onto a reference to the array—even if it never uses it.

class SuperSecretDocument
  def initialize(original_document, time_limit_seconds)
    @original_document = original_document
    @time_limit_seconds = time_limit_seconds
    @create_time = Time.now
  end

  def time_expired?
    Time.now - @create_time >= @time_limit_seconds
  end

  def check_for_expiration
    raise 'Document no longer available' if time_expired?
  end

  def method_missing(name, *args)
    check_for_expiration
    @original_document.send(name, *args)
  end
end

string = 'Good morning, Diana'
secret_string = SuperSecretDocument.new( string, 5 )
puts secret_string.length           # Works fine
sleep 6
puts secret_string.length           # Raises an exception


