$dir = File.dirname(__FILE__)
require File.expand_path('simple', $dir)

# ###########################
# First, test Module#autoload
# ###########################

module A
  autoload(:B, $dir + '/AutoloadHelper.rb')
end

test(defined? :A,   'expression',  ":A should be defined before")
test(defined? A::B, nil, "A::B should not be defined before autoload")
test(defined? A::B, nil, "calling defined? should NOT have defined A::B")
test($marker, nil, "$marker should be nil before the autoload")

# Now reference A::B to force the autoload
A::B.new

test(defined? :A, 'expression' ,   ":A should be defined after")
test(defined? A::B, 'constant', "A::B should be defined after autoload")
test($marker, true, "$marker should not be nil after the autoload")

# ###########################
# Now test the Kernel.autoload
# ###########################

test(autoload?(:Foo), nil, 'Kernel autoload?')

autoload(:Foo, $dir + '/AutoloadHelper2.rb')
test(Foo::AConstant, "Some value", 'Kernel autoload')

true
