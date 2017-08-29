require_relative 'player'

class Computer < Player
  def set_name
    self.name = self.class.name
  end
end
