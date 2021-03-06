class GsNMethod
   # Gemstone compiled methods  are instances of GsNMethod
   #  subclasses of GsNMethod is not allowed
   #  extending GsNMethod is not allowed outside of bootstrap

   primitive_nobridge '__call_star*&' , '_executeInContext:star:block:'

   primitive_nobridge 'inspect', '_rubyInspect' 
end

class Method
    # Method is identically Smalltalk RubyMeth
    #   RubyMethod is defined in the .mcz

    def __obj
      @obj
    end

    def ==(other)
      # Returns true if other is the same method as self
      if (other.kind_of?(Method))
        return @obj.equal?(other.__obj) &&
         @gsmeth.equal?(other.__gsmeth)
      else
        return false
      end
    end

    # arity inherited from UnboundMethod

    def call(*args, &blk)
      @gsmeth.__call_star(@obj, *args, &blk)
    end

    def [](*args, &blk)
      @gsmeth.__call_star(@obj, *args, &blk)
    end

    alias_method :eql? , :==

    def to_proc
      p = Proc.new { |*args| self.call(*args) }
      p.__arity=( self.arity )
      p
    end

    primitive_nobridge 'unbind', 'unbind'
end
