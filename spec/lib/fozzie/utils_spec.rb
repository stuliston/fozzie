require 'spec_helper'

describe Fozzie::Utils do
  
  it ".origin_name" do
    described_class.origin_name.should_not be_nil
  end
  
end