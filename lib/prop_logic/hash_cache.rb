require 'prop_logic'

# monkey-patching cache generation
class PropLogic::Term
  def self.generate_cache
    {}
  end
end
