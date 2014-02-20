# == Schema Information
#
# Table name: exercise_media
#
#  id             :integer          not null, primary key
#  context_id     :integer
#  context_type   :string(255)
#  owner_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#  code           :string(255)
#  token          :string(255)
#

require 'spec_helper' 

describe ExerciseMedium do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:exercise_medium).valid?).to be_true
  end

  it "should have a title" do
    expect(FactoryGirl.build(:exercise_medium, title: '').valid?).to be_false
  end

  it "should have a short title" do
    expect(FactoryGirl.build(:exercise_medium, short_title: '').valid?).to be_false
  end

  it "should have a code" do
    expect(FactoryGirl.build(:exercise_medium, code: '').valid?).to be_false
  end

  it "should have a description" do
    expect(FactoryGirl.build(:exercise_medium, description: '').valid?).to be_false
  end

  it "should return an error if the title is empty" do
    expect(FactoryGirl.build(:exercise_medium, title: '')).to have(1).error_on(:title)
  end

  it "should have a context" do
    expect(FactoryGirl.build(:exercise_medium, context: nil).valid?).to be_false
  end

  it "should return an error if the context is empty" do
    expect(FactoryGirl.build(:exercise_medium, context: nil)).to have(1).error_on(:context)
  end


  it "should have just one translation" do
    expect(FactoryGirl.create(:exercise_medium).translations.length).to eql(1)
  end

  it "should have a translation with locale that matches i18n locale" do
    expect(FactoryGirl.create(:exercise_medium).translations.first.locale).to eql(I18n.locale)
  end

  it "should add a translation for the new language" do
    I18n.locale = :en

    ex = FactoryGirl.create(:exercise_medium)
    ex.update_attributes!(:title => 'Titel v3')

    I18n.with_locale(:de) do
      ex.update_attributes!(:title => 'Titel v1', :short_title=>'das', :description=>'hunde')
    end

    expect(ex.translations.length).to eql(2)
  end

  it "should add return the exercise with the correct language" do
    I18n.locale = :en

    ex = FactoryGirl.create(:exercise_medium)
    ex.update_attributes!(:title => 'Titel v3')

    I18n.with_locale(:de) do
      ex.update_attributes!(:title => 'Danke', :short_title=>'katze', :description=>'hunde')
    end

    I18n.with_locale(:de) do
      expect(ExerciseMedium.with_translations('de').first.title).to eql('Danke')
    end

    I18n.with_locale(:en) do
      expect(ExerciseMedium.with_translations('en').first.title).to eql('Titel v3')
    end
    
  end

  

 
end 
