require 'spec_helper'

describe YARG::DataStore do

  describe 'DataStore.where(type: :given_name)' do

    let :tagged_data_files do
      {
        given_names_male_us: { type: :given_name, gender: :male, region: :us },
        given_names_female_us: { type: :given_name, gender: :female, region: :us },
        surnames_us: { type: :surname, region: :us }
      }
    end

    before do
      YARG::DataStore.stub(:tagged_data_files).and_return tagged_data_files
    end

    it 'returns an array of given names' do
      expected_names = [['Aaron', 'Mike'], ['Sarah']]
      YARG::DataStore.stub(:fetch_data).and_return *expected_names

      names = YARG::DataStore.where(type: :given_name)
      names.should == expected_names.flatten
    end

    it 'returns an array of female given names' do
      female_names = ['Adela', 'Nancey']
      male_names = ['Thomas', 'John']

      YARG::DataStore.stub(:fetch_data).with(:given_names_male_us).and_return male_names
      YARG::DataStore.stub(:fetch_data).with(:given_names_female_us).and_return female_names

      names = YARG::DataStore.where(type: :given_name, gender: :female)
      names.should == female_names
    end

    it 'returns an array of surnames' do
      expected_surnames = ['Smith', 'Locke']
      YARG::DataStore.stub(:fetch_data).and_return expected_surnames

      surnames = YARG::DataStore.where(type: :surname)
      surnames.should == expected_surnames
    end
  end
end