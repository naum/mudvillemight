require 'securerandom'

class Ballplayer

  attr :name, :pos, :skill

  def initialize(name, pos)
    @name, @pos = name, pos
    @skill = (1..4).map { |_| Ballplayer.rand_skill }
  end

  def self.rand_skill
    # 0: 125 + 0
    # 1: 75 + 125
    # 2: 15 + 75
    # 3: 1 + 15
    # 4: 0 + 1
    x = SecureRandom.rand(432)
    if x < 125
      0
    elsif x < 325
      1
    elsif x < 415
      2
    elsif x < 431
      3
    else
      4
    end
  end

  def worth
    @skill.inject :+
  end

end

class League

  attr :cities, :freeagents, :title

  POS_CHART = 'OOOIIIICPPPP'
  TOTAL_TEAMS = 20

  def initialize()
    @title = 'UBA'
    genesis
  end

  def assign_freeagents
 
  end

  def genesis()
    np = Namepool.new
    @cities = []
    @freeagents = []
    TOTAL_TEAMS.times do
      @cities << np.draw_loc
      POS_CHART.each_char do |p|
        @freeagents << Ballplayer.new(np.draw, p)
      end
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

class Team 

  attr :city, :lineup, :rotation

  MAX_ROSTER_SIZE = 12

  def initialize(city)
    @city = city
    @lineup = []
    @rotation = []
  end

  def acquire(ballplayer)
    if ballplayer.pos == 'P'
      @rotation << ballplayer
    else
      @lineup << ballplayer
    end
  end

  def roster
    @lineup + @rotation
  end

  def roster_full?
    roster.size >= MAX_ROSTER_SIZE
  end

end