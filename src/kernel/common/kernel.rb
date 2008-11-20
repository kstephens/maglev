# All the code in this file comes from rubinius common/kernel.rb.  But, not
# all of the code in common/kernel.rb is in here...
#
# TODO move code to a Gemstone directory; it has been edited to
#   avoid message sends if coercion not required, and
#    to workaround module_function not working for Kernel
#
module Kernel
  def self.Float(obj)
    if (obj._isFloat) 
      return obj
    end
    raise TypeError, "can't convert nil into Float" if obj.nil?
    if obj._isString
      if obj !~ /^(\+|\-)?\d+$/ && obj !~ /^(\+|\-)?(\d_?)*\.(\d_?)+$/ && obj !~ /^[-+]?\d*\.?\d*e[-+]\d*\.?\d*/
	raise ArgumentError, "invalid value for Float(): #{obj.inspect}"
      end
    end
    Type.coerce_to(obj, Float, :to_f)
  end

  # TODO: module_function not working for Kernel,  
  #  Kernel still an instance of Class, not instance of Module
  # module_function :Float
  def Float(obj)
    if obj._isFloat
      return obj
    end
    Kernel.Float(obj)
  end

  # module_function :Integer
  def self.Integer(obj)
    if (obj._isInteger)
      return obj
    end
    if obj._isString
      if obj == ''
	raise ArgumentError, "invalid value for Integer: (empty string)"
      else
	return obj.to_inum(0, true)
      end
    end
    if (obj.respond_to?(:to_int))
      Type.coerce_to(obj, Integer, :to_int)
    else
      Type.coerce_to(obj, Integer, :to_i)
    end
  end

  def Integer(obj)
    if (obj._isInteger)
      return obj
    end
    Kernel.Integer(obj)
  end

  # module_function :Array
  def self.Array(obj)
    if obj._isArray 
      return obj
    end 
    if obj.respond_to?(:to_ary)
      Type.coerce_to(obj, Array, :to_ary)
    elsif obj.respond_to?(:to_a)
      Type.coerce_to(obj, Array, :to_a)
    else
      [obj]
    end
  end

  def Array(obj)
    if  obj._isArray 
      return obj
    end
    Kernel.Array(obj)
  end


  def String(obj)
    Type.coerce_to(obj, String, :to_s)
  end

  # module_function :String
  def self.String(obj)
    Type.coerce_to(obj, String, :to_s)
  end

  ##
  # MRI uses a macro named NUM2DBL which has essentially the same semantics as
  # Float(), with the difference that it raises a TypeError and not a
  # ArgumentError. It is only used in a few places (in MRI and Rubinius).
  #--
  # If we can, we should probably get rid of this.

  def FloatValue(obj)
    begin
      Float(obj)
    rescue
      raise TypeError, 'no implicit conversion to float'
    end
  end
#  private :FloatValue   # TODO: uncomment
end