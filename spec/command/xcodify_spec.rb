require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Xcodify do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ xcodify }).should.be.instance_of Command::Xcodify
      end
    end
  end
end

