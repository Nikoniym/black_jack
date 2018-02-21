class Card
  attr_reader :view, :value

  def initialize(view, value)
    @view = view
    @value = value
  end
end
