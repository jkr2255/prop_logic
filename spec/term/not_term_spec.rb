require 'spec_helper'

describe PropLogic::NotTerm do
  let(:terms) do
    a = PropLogic::new_variable 'a'
	b = PropLogic::new_variable 'b'
	{
		variable: !a,
		not: !!a,
	}
  end
end
