shared_examples_for "fozzie adapter" do

  it { should respond_to(:register) }

  it { should respond_to(:delimeter) }

  it { should respond_to(:safe_separator)  }

end
