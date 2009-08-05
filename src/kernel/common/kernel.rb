# All the code in this file comes from rubinius common/kernel.rb.  But, not
# all of the code in common/kernel.rb is in here...
#
# TODO move code to a Gemstone directory; it has been edited to
#   avoid message sends if coercion not required, and
#    to workaround module_function not working for Kernel
#
module Kernel
  def Float(obj)
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

  module_function :Float

  def Integer(obj)
    if (obj._isInteger)
      return obj
    end
    if obj._isString
      if obj.size.equal?(0)
	raise ArgumentError, "invalid value for Integer: (empty string)"
      end
      if obj[0].equal?(0) || obj[-1].equal?(0)  # begin/end with null byte
	raise ArgumentError, "invalid value for Integer: (null byte)"
      end
      return obj.to_inum(0, true)
    end
    if obj.equal?(nil)
      return 0
    end
    val = nil
    begin
      val = obj.to_int
    rescue Exception
    end
    if val.equal?(nil)
      begin
        val = obj.to_i
      rescue Exception
      end
    end  
    unless val._isInteger
      raise TypeError, 'Coercion error: to_int or to_i did not return an Integer'
    end
    val
  end
  module_function :Integer

  def Array(obj)
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
  module_function :Array

  def String(obj)
    Type.coerce_to(obj, String, :to_s)
  end

  module_function :String

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

  def warn(warning)
    $stderr.write "#{warning}\n" unless $VERBOSE.equal?(nil)
    nil
  end
  module_function :warn

end
