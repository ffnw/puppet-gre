require 'spec_helper'
describe 'gre' do

  context 'with defaults for all parameters' do
    it { should contain_class('gre') }
  end
end
