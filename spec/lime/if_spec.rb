require "lime"
using Lime::If

RSpec.describe "Lime::If" do
  it "takes self as its condition by default" do
    expect { true.if.then { throw :called } }.to throw_symbol
    expect { false.if.then { throw :called } }.not_to throw_symbol
  end

  it "takes a block argument" do
    expect { true.if { _1 }.then { throw :called } }.to throw_symbol
    expect { false.if { _1 }.then { throw :called } }.not_to throw_symbol
    expect { nil.if(&:nil?).then { throw :called } }.to throw_symbol
  end

  it "takes a value" do
    expect { true.if(true).then { throw :called } }.to throw_symbol
    expect { true.if(false).then { throw :called } }.not_to throw_symbol
  end
end
