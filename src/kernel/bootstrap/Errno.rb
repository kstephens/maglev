module Errno
  # Given a return value from a "system or library" call, raise the
  # appropriate exception if any.  If +err+ is not a small integer, or if
  # it is 0, then return +err+ (i.e., there was no problem, so just return
  # the status to caller). Otherwise, interpret +err+ as a Unix errno and
  # raise the correct exception.
  #
  # In the non-errno cases, handle returns err so that client code can be
  # written like:
  #     def Dir.getwd
  #       Errno.handle(_getwd, "Dir.getwd")
  #     end
  def self.handle(err, additional = nil)
    return err unless err._isSmallInteger  # Not an errno
    return err if err == 0                 # errno signifying no error

    # TODO: Errno: need to map errno to correct Exception
    raise SystemCallError, "System error (errno: #{err}): #{additional}"
  end

  # TODO: Errno.rb: Map system dependent errno ints to common Errno class

  #    We may want to make Errno::EBADF::Errno map to a method call so that
  #    we can map platform specific errnos to the correct, shared,
  #    Errno::EBADF class.  We want one Smalltalk image to be usable on
  #    several platforms, so we need to make sure platform specific errno
  #    ints from the underlying platform map to the correct SystemCallError
  #    subclass.
  #
  #    Another way we could do this is to implement const_missing for the
  #    Errno::EBADF classes and have that call Errno.errno_for(sym).  See
  #    commented code below.
  #
  # Create a class to represent +errno+.  A constant, +name+, will be added to
  # +Errno+ to store the class and the class will have the value of its
  # constant +Errno+ be +errno+.  E.g.,
  #   <tt>_createErrnoClass(9, 'EBADF')</tt>
  # will create :
  #
  #     <tt>Errno::EBADF         # => A class representing Errno number 9.</tt>
  #     <tt>Errno::EBADF::Errno  # => 9</tt>
  def self._createErrnoClass(errno, name)
    klass = Class.new(SystemCallError)
    const_set(name, klass)

    # TODO: Currently, const_set is just stubbed out, so this doesn't work...
    klass.const_set(:Errno, errno)  # TODO: Hack for now.
    # If we want to add a const_missing hook, then comment out the above
    # line and do something like this instead:
#     klass.instance_eval do
#       def const_missing(sym)
#         if sym.to_str == 'Errno'
#           my_name = self.name.split('::')[-1]
#           Errno.errno_names.index[my_name] + 1
#         else
#           raise NameError, "uninitialized constant #{self}::#{sym}"
#         end
#       end
#     end
  end

  # Return an array of errno names, indexed by errno for this platform.
  def self.errno_names
    Exception._errnoTables[Exception._cpuOsKind - 1] # Adjust for smalltalk
  end

  def self.createAllErrnoClasses
    table = Errno.errno_names
    table.each_with_index { |name, errno| Errno._createErrnoClass(errno, name)}
  end



end

Errno.createAllErrnoClasses

