require 'binder/tell'

describe "Tell" do 
  it "should raise an error if an object isn't passed to it" do
    proc {Tell()}.should raise_error(ArgumentError)
  end

  it "should not raise an error if an object, but not a block, is passed to it" do
    proc {Tell "hello"}.should_not raise_error
    Tell("hello").should == nil
  end

  it "should run an instance_eval on the object" do
    str = "hello"
    str.should_receive(:instance_eval).and_return :hello
    Tell(str) { to_sym }
  end

  it "should run the block within the context of the object" do
    Tell("hi") { to_sym }.should == :hi
  end
end
