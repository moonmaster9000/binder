def Tell(obj, &block)
  obj.instance_eval(&block) if block
end
