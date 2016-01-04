module PropLogic
  module Functions
    def all_or(*args)
      Term.get OrTerm, *args
    end
    
    def all_and(*args)
      Term.get AndTerm, *args
    end
    
    def new_variable(*args)
      Variable.new *args
    end
  end
  
  extend Functions
  
  def all_combination(arr)
    0.upto(arr.length) do |num|
      arr.combination(num){|c| yield c}
    end
  end
  
  module_function :all_combination
  
end
