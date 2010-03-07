module Binder
  def bind(method_name, closure)
    raise ArgumentError, "You may only pass symbols to #bind" unless closure.kind_of?(Symbol)
    
    if closure == :self
      self.class_eval do
        eval(
          "
          def #{method_name}(&block)
            if block
              block.bind_to(self).call
            end
          end
          "
        )
      end
    else
      self.class_eval do
        eval(
          "
          def #{method_name}(&block)
            if block
              # if we're suposed to bind an object returned by a method
              if self.respond_to?(:#{closure})
                block.bind_to(self.#{closure}).call
              # if self has an instance variable 
              elsif @#{closure}
                block.bind_to(@#{closure}).call
              else
                raise StandardError, \"Trying to bind to an unknown method or variable: #{closure}\"
              end
            end
          end
          "
        )
      end
    end      
  end
end
