# trac 383
class Base
  @@cva = 9
  class << self
    @@cvb = 10
    def checkb
      x = @@cvb
      fail "Expecting non nil " if x.nil?
    end
  end
  def geta
    x = @@cva  # _rubyClassVarGet:
    unless x == 9 ; raise 'err' ; end
    @@cvc = 11
  end
  def self.getc
    @@cvd = 12
    @@cvc
  end
  def getd
    x = @@cvd
    unless x == 12 ; raise 'error' ; end
  end
end

Base.new.geta
Base.getc
Base.new.getd
Base.checkb
true
