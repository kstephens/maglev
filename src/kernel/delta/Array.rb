class Array
  # The include of Enumerable is necessary so that the specs that ensure
  # Array includes Enumerable pass.  We immediately override most of
  # Enumerable (but *do* pick up on the sort).
  include Enumerable

  # These are the overrides of Enumerable for performance reasons
  #
  # TODO: After Enumerable is implemented, we should re-visit these and
  # ensure only the methods critical for performane or Array specific
  # implementations are implemented here.

  def all?(&b)
    _all(b)
  end

  primitive 'any?&', 'anySatisfy:'

  def collect(&b)
    result = Array.new(length)
    i = 0
    lim = size
    while i < lim
      result[i] = b.call(self[i])
      i += 1
    end
    result
  end

  def detect(&block)
    _detect(block, nil)
  end

  def each_with_index(&block)
    i = 0
    lim = size
    while i < lim
      block.call(self[i],i)
      i += 1
    end
  end

  alias entries to_a

  def find(&block)
    _detect(block, nil)
  end

  def find_all(&block)
    result = []
    i = 0
    lim = size
    while i < lim
      el = self[i]
      result << el if block.call(el)
      i += 1
    end
    result
  end

  def grep(pattern)
    select{|ea| pattern === ea}
  end

  # TODO: include?: The Pick Axe book documents include? under both Array
  # and Enumerable. Our implementation is in the Array section above.

  primitive 'inject&', 'inject:into:'

  alias map collect

  def max
    if size.equal?(0)
      nil
    else
      max_v = self[0]
      i = 1
      lim = size
      while i < lim
        max_v = self[i] if (self[i] <=> max_v) > 0
        i += 1
      end
      max_v
    end
  end

  primitive 'member?', 'includes:'

  def min
    if size.equal?(0)
      nil
    else
      min_v = self[0]
      i = 1
      lim = size
      while i < lim
        min_v = self[i] if (self[i] <=> min_v) < 0
        i += 1
      end
      min_v
    end
  end

  def partition(&b)
    t = []
    f = []
    i = 0
    lim = size
    while i < lim
      el = self[i]
      if(b.call(el))
        t << el
      else
        f << el
      end
      i += 1
    end
    [t,f]
  end

  def reject(&b)
    result = []
    i = 0
    lim = size
    while i < lim
      result << self[i] unless b.call(self[i])
      i += 1
    end
    result
  end

  primitive 'select&', 'select:'

  # sort: is listed in the Pick Axe book under both Array and Enumerable,
  # and implemented here in the Array section above.

  # PickAxe p 457 documents that sort_by uses Schwartzian Transform
  # sort_by  implemented in Array section above

  # to_a: Implemented above in the Array section

  def zip(*args)
    result = []
    args = args.map { |a| a.to_a }  # TODO: loop-ize
    i = 0
    lim = size
    while i < lim
      ary = [self[i]]

      j = 0
      while j < args.length
        ary << args[j][i]
        j += 1
      end
      # b.call(ary)...
        yield(ary) if block_given?
      result << ary
      i += 1
    end
    result
  end
end