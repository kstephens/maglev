require File.expand_path('simple', File.dirname(__FILE__))

# Test with string as name
Struct.new("Customer", :name, :address)
dave = Struct::Customer.new("Dave", "123 Main")

test(dave.name,    "Dave",     "Struct A")
test(dave.address, "123 Main", "Struct B")
test(Struct.constants.include?("Customer"), true, "Struct C")

# Test creating anonymous struct
X = Struct.new(:a, :b)
x = X.new("A1", "B1")
test(x.a, "A1", "Struct X#a")
test(x.b, "B1", "Struct X#b")

report
true
