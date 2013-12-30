require 'spec_helper' 

describe Exercise do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:exercise).valid?).to be_true
  end

  it "should have a title" do
    expect(FactoryGirl.build(:exercise, title: '').valid?).to be_false
  end

  it "should have a short title" do
    expect(FactoryGirl.build(:exercise, short_title: '').valid?).to be_false
  end

  it "should have a code" do
    expect(FactoryGirl.build(:exercise, code: '').valid?).to be_false
  end

  it "should have a description" do
    expect(FactoryGirl.build(:exercise, description: '').valid?).to be_false
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


  it "should have just one translation" do
    expect(FactoryGirl.create(:exercise).translations.length).to eql(1)
  end

  it "should have a translation with locale that matches i18n locale" do
    expect(FactoryGirl.create(:exercise).translations.first.locale).to eql(I18n.locale)
  end

  it "should add a translation for the new language" do
    I18n.locale = :en

    ex = FactoryGirl.create(:exercise)
    ex.update_attributes!(:title => 'Titel v3')

    I18n.with_locale(:de) do
      ex.update_attributes!(:title => 'Titel v1', :short_title=>'das', :description=>'hunde')
    end

    expect(ex.translations.length).to eql(2)
  end

  it "should add return the exercise with the correct language" do
    I18n.locale = :en

    ex = FactoryGirl.create(:exercise)
    ex.update_attributes!(:title => 'Titel v3')

    I18n.with_locale(:de) do
      ex.update_attributes!(:title => 'Danke', :short_title=>'katze', :description=>'hunde')
    end

    I18n.with_locale(:de) do
      expect(Exercise.with_translations('de').first.title).to eql('Danke')
    end

    I18n.with_locale(:en) do
      expect(Exercise.with_translations('en').first.title).to eql('Titel v3')
    end
    
  end

  

 
end 