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

class BatterStatRec

  attr :team, :ab, :h, :d, :t, :hr, :rbi, :k, :w

  def initialize t
    @team = t
    @ab, @h, @d, @t, @hr, @rbi, @k, @w = 0, 0, 0, 0, 0, 0, 0, 0
  end

end

class League

  attr :freeagents, :schedule, :standings, :teams, :title
  attr :batterstat, :pitcherstat

  POS_CHART = 'BBBBBBBBPPPP'
  TOTAL_TEAMS = 20

  def initialize()
    @title = 'UBA'
    genesis
  end

  def assign_freeagents
    batter_pool = @freeagents.select {|fa| fa.pos == 'B'}
    pitcher_pool = @freeagents.select {|fa| fa.pos == 'P'}
    batter_pool.shuffle!
    pitcher_pool.shuffle!
    @teams.each do |c, t|
      until t.lineup_full? do 
        t.acquire(batter_pool.pop) 
      end
      until t.rotation_full? do 
        t.acquire(pitcher_pool.pop) 
      end
    end
    @freeagents = batter_pool + pitcher_pool
  end

  def genesis()
    np = Namepool.new
    @freeagents = []
    @teams = {}
    @standings = {}
    TOTAL_TEAMS.times do
      city = np.draw_loc
      @teams[city] = Team.new
      POS_CHART.each_char do |p|
        @freeagents << Ballplayer.new(np.draw, p)
      end
    end
    assign_freeagents
    init_standings
    init_stat_recs
  end

  def init_standings
    @teams.keys.each do |c|
      @standings[c] = StandingRec.new(c)
    end
  end

  def init_stat_recs
    @teams.each do |c, t|
      t.lineup.each do |bp|
        @batterstat[bp.name] = BatterStatRec.new(c)
      end
      t.rotation.each do |bp|
        @pitcherstat[bp.name] = PitcherStatRec.new(c)
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

class PitcherStatRec

  attr :team, :ip, :w, :l, :h, :hr, :r, :so, :bb 

  def initialize t
    @team = t
    @ip, @w, @l, @h, @hr, @r, @so, @bb = 0, 0, 0, 0, 0, 0, 0, 0
  end

end

class StandingRec

  attr :city, :w, :l, :rs, :ra

  def initialize(c)
    @city = c
    @w, @l, @rs, @ra = 0, 0, 0, 0
  end

  def win_pct
    if (@w + @l) > 0 
      return @w / (@w + @l)
    else
      return 0
    end
  end

end

class Team 

  attr :lineup, :rotation

  MAX_LINEUP_SIZE = 8
  MAX_ROTATION_SIZE = 4
  MAX_ROSTER_SIZE = MAX_LINEUP_SIZE + MAX_ROTATION_SIZE

  def initialize
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

  def lineup_full?
    @lineup.size >= MAX_LINEUP_SIZE
  end

  def roster
    @lineup + @rotation
  end

  def roster_full?
    roster.size >= MAX_ROSTER_SIZE
  end

  def rotation_full?
    @rotation.size >= MAX_ROTATION_SIZE
  end

end