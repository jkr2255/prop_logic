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
end
