# frozen_string_literal: true

RSpec.describe GamePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:game) { create(:game, user: user) }

  subject { GamePolicy }

  permissions :show? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, game)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, game)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, game)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, game)
    end
  end

  permissions :create? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, game)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, game)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, game)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, game)
    end
  end

  permissions :edit? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, game)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, game)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, game)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, game)
    end
  end

  permissions :update? do
    it 'denies access to visitors' do
      no_user = nil
      expect(subject).not_to permit(no_user, game)
    end

    it 'denies access to non-author users' do
      different_user = create(:user)
      expect(subject).not_to permit(different_user, game)
    end

    it 'permits access to author users' do
      expect(subject).to permit(user, game)
    end

    it 'permits access to non-author admin users' do
      admin = create(:user, admin: true)
      expect(subject).to permit(admin, game)
    end
  end
end
