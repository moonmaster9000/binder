require 'spec_helper'
require 'binder/shackles'

describe Object do
  describe "##bind" do
    it "should create a new instance method that evaluates the block passed it within the requested closure" do
      proc do
        class Platypus
          bind :do_trick, "invalid argument"
        end
      end.should raise_error(ArgumentError, "You may only pass symbols to #bind")
      
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
  
    describe "#bind in the singleton class" do
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
          class << self
            bind :tame, :self
            bind :do_trick, :child
          
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
