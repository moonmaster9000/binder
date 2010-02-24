class Object
  def tell(closure, relayed_message=nil, &message)
    if relayed_message && relayed_message.kind_of?(Proc)
      closure.instance_eval(&relayed_message)
    elsif message 
      closure.instance_eval(&message)
    else
      raise StandardError, "What is your command?"
    end
  end
    
  class << self    
    def bind_in_context(method_name, closure, eval_context=:class_eval)
      raise ArgumentError, "You may only pass symbols to #bind and #bind_class_method" unless closure.kind_of?(Symbol)
      if closure == :self
        self.send(eval_context) do
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
        self.send(eval_context) do
          eval(
            "
            def #{method_name}(&block)
              if block
                if self.respond_to?(:#{closure})
                  block.bind_to(self.#{closure}).call
                elsif @#{closure}
                  block.bind_to(@#{closure}).call
                else
                  block.bind_to(self.#{closure}).call
                end
              end
            end
            "
          )
        end
      end      
    end
    
    alias_method :bind, :bind_in_context
    
    def bind_class_method(method_name, closure)
      bind_in_context method_name, closure, :instance_eval
    end
  end
end
