class League

  attr :cities, :freeagents, :title

  POS_CHART = 'OOOOIIICPPPP'
  TOTAL_TEAMS = 20

  def initialize()
    @title = 'UBA'
    genesis
  end

  def genesis()
    np = Namepool.new
    @cities = []
    @freeagents = []
    TOTAL_TEAMS.times do
      @cities << np.draw_loc
    end
  end

end


class Namepool

  DICTFILE = '/usr/share/dict/words'

  def initialize
    words = IO.read(DICTFILE).split("\n")
    goodwords = words.select { |w| w =~ /^\w{2,12}$/ }
    properwords = words.select { |w| w =~ /^[A-Z]\w{1,11}$/}
    @namepool = goodwords.map { |w| w.upcase }
    @namepool.shuffle!
    @locpool = properwords.map { |w| w.upcase }
    @locpool.shuffle!
  end

  def draw 
    @namepool.pop
  end

  def draw_loc
    @locpool.pop
  end

end