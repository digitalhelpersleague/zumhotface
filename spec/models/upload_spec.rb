require 'rails_helper'

RSpec.describe Upload, type: :model do
  let(:current_user) { create(:user) }

  context 'Language detection' do
    it 'should detect upload\'s language' do
      upload = create(:blob,
        user: current_user,
        file: File.open(
          Rails.root.join('spec', 'fixtures', 'hello_world.rb')
        )
      )
      upload.detect_language
      expect(upload.lang).to eq('Ruby')
    end
  end

end
