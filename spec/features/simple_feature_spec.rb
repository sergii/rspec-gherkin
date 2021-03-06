require 'spec_helper'

feature 'A simple feature' do
  # ensure background is executed as before(:each)
  background do
    @number ||= 41
    @number += 1 
  end

  scenario 'A simple scenario' do
    expect(@number).to eq(42)
  end

  scenario 'Raising error' do
    raise ArgumentError.new("Your argument is invalid!")
  end

  scenario 'Diferant metadata type', :type => :controller, :feature => false do
    expect(example.metadata[:type]).to eq(:controller)
    expect(example.metadata[:feature]).to eq(false)
  end

  scenario 'Custom metadata tag', :custom => "foobar" do
    expect(example.metadata[:custom]).to eq("foobar")
  end
end
