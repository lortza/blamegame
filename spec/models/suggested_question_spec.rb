require 'rails_helper'

RSpec.describe SuggestedQuestion, type: :model do
  context 'validations' do
    it { should validate_presence_of(:text) }
  end

  describe 'self.mark_as_processed' do
    it 'returns nil if id is not present' do
      id = nil
      result = SuggestedQuestion.mark_as_processed(id)
      expect(result).to be(nil)
    end

    it 'updates processed_at with the current timestamp' do
      suggested_question = create(:suggested_question)
      expect(suggested_question.processed_at).to be(nil)

      result = SuggestedQuestion.mark_as_processed(suggested_question.id)
      suggested_question.reload
      
      expect(suggested_question.processed_at).to_not be(nil)
    end
  end
end
