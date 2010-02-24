require 'spec_helper'

describe Object do
  describe "#tell" do
    it "should run the given block or proc inside the requested object closure" do
      class Baby
        def say_dada
          "waaaa"
        end
      end
            
      Object.new.tell(Baby.new) { say_dada }.should == "waaaa"
      Object.tell(Baby.new) { say_dada }.should == "waaaa"
      tell(Baby.new) { say_dada }.should == "waaaa"
      
      tell Baby.new, :to do
        say_dada
      end

      to_say_dada = proc { say_dada }      
      Object.new.tell(Baby.new, to_say_dada).should == "waaaa"
      Object.tell(Baby.new, to_say_dada).should == "waaaa"
      tell(Baby.new, to_say_dada).should == "waaaa"
    end
  end

  describe "##bind" do
    it "should create a new instance method that evaluates the block passed it within the requested closure" do
      proc do
        class Platypus
          bind :do_trick, "invalid argument"
        end
      end.should raise_error(ArgumentError, "You may only pass symbols to #bind and #bind_class_method")
      
      class Dog
        bind :do_trick, :self
      
        def speak
          "ruff!"
        end
      end
    
      Dog.new.do_trick { speak }.should == "ruff!"
    
      class Cat
        bind :do_trick, :class
      
        class << self
          def speak
            "screw you"
          end
        end
      
        def speak
          "bugger off"
        end
      end
    
      Cat.new.do_trick { speak }.should == "screw you"
    
      class Kitten
        bind :do_trick, :mother
      
        def initialize(mom)
          @mother = mom
        end
      end 
    
      Kitten.new(Cat).do_trick { speak }.should == "screw you"
      Kitten.new(Cat.new).do_trick { speak }.should == "bugger off"
      Kitten.new(Dog.new).do_trick { speak }.should == "ruff!"
    
    end
  
    describe "#bind_class_method" do
      it "should create a class method responder that binds to either a new class or the return value of a class method" do
        class Cat
          bind :do_trick, :class

          class << self
            def speak
              "screw you"
            end
          end

          def speak
            "bugger off"
          end
        end
        
        class Lion
          bind_class_method :tame, :self
          bind_class_method :do_trick, :child
          class << self
            def down_kitty
              "meow"
            end

            def child
              @child ||= Cat
            end
          end
        end

        Lion.tame {down_kitty}.should == "meow"
        Lion.do_trick { speak }.should == "screw you"
      end
    end
  end
end
