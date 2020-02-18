class League

  def initialize()
    @title = 'UBA'
  end

  def genesis()
    @freeagents = []
  end

end


class Namepool

  DICTFILE = '/usr/share/dict/words'

  def initialize() 
    words = IO.read(DICTFILE).split("\n")
    goodwords = words.select { |w| w =~ /^\w{2,12}$/ }
    @namepool = goodwords.map { |w| w.upcase }
    @namepool.shuffle!
  end

  def draw() 
    @namepool.pop
  end

end