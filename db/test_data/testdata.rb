require 'models'
class TestData 
  def run
    for i in 1..100 do
      Project.create( :name => "Dave #{i}");
    end
  end

end