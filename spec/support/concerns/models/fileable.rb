require 'rails_helper'

RSpec.shared_examples_for 'fileable' do
  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
