# frozen_string_literal: true

RSpec.describe DeckPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:deck) { create(:deck, user: user) }

  subject { DeckPolicy }

  permissions :show? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, deck)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, deck)
    end

    it 'denies access to author users' do
      expect(subject).not_to permit(user, deck)
    end

    it 'denies access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to_not permit(admin, deck)
    end
  end

  permissions :create? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, deck)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, deck)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, deck)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, deck)
    end
  end

  permissions :edit? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, deck)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, deck)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, deck)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, deck)
    end
  end

  permissions :update? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, deck)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, deck)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, deck)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, deck)
    end
  end

  permissions :destroy? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, deck)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, deck)
    end

    it 'denies access to author users' do
      expect(subject).not_to permit(user, deck)
    end

    it 'denies access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).not_to permit(admin, deck)
    end
  end
end
