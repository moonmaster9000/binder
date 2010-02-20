class Proc
  def bind_to(some_object)
    Proc.new do 
      some_object.instance_eval(&self)
    end
  end
end