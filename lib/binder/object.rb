class Object
  class << self
    def bind(method_name, closure)
      if !closure.kind_of?(Symbol)
        closure = closure.to_s
      else   
        closure = closure == :self ? "self" : "@#{closure}"
      end
      
      self.class_eval do
        eval(
          "
            def #{method_name}(&block)
              raise ArgumentError, \"You must pass a block to ##{method_name}.\" unless block
              block.bind_to(#{closure}).call
            end
          "
        )
      end
    end
    
    def bind_class_method(method_name, closure)
      if !closure.kind_of?(Symbol)
        closure = closure.to_s
      else   
        closure = closure == :self ? "self" : "#{closure}"
      end
      
      self.class_eval do
        eval(
          "
            class << self
              def #{method_name}(&block)
                raise ArgumentError, \"You must pass a block to ##{method_name}.\" unless block
                block.bind_to(#{closure}).call
              end
            end
          "
        )
      end
    end
  end
end