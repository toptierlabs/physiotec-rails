require 'spec_helper' 

describe Exercise do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:exercise).valid?).to be_true
  end

  it "should have a title" do
    expect(FactoryGirl.build(:exercise, title: '').valid?).to be_false
  end

  it "should return an error if the title is empty" do
    expect(FactoryGirl.build(:exercise, title: '')).to have(1).error_on(:title)
  end

  it "should have a context" do
    expect(FactoryGirl.build(:exercise, context: nil).valid?).to be_false
  end

  it "should return an error if the context is empty" do
    expect(FactoryGirl.build(:exercise, context: nil)).to have(1).error_on(:context)
  end


 
end 