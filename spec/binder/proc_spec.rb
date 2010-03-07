require 'spec_helper'
require 'binder/proc'

describe Proc do
  describe "#bind_to" do
    it "should return a proc bound to a new context" do
      def speak
        "why should i?"
      end
      
      class Dog
        def speak
          "ruff!"
        end
      end
      
      trick = proc { speak }
      
      trick.call.should == "why should i?"
      trick.bind_to(Dog.new).call.should == "ruff!"
    end
  end
end
