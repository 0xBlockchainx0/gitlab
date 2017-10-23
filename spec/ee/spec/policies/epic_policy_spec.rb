require 'spec_helper'

describe EpicPolicy do
  let(:user) { create(:user) }

  def permissions(user, group)
    epic = create(:epic, group: group)

    described_class.new(user, epic)
  end

  context 'when an epic is in a private group' do
    let(:group) { create(:group, :private) }

    it 'non loged user can not read epics' do
      expect(permissions(nil, group))
        .to be_disallowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'user who is not a group memper can not read epics' do
      expect(permissions(user, group))
        .to be_disallowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'guest group memper can only read epics' do
      group.add_guest(user)

      expect(permissions(user, group)).to be_allowed(:read_epic)
      expect(permissions(user, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'reporter group memper can manage epics' do
      group.add_reporter(user)

      expect(permissions(user, group))
        .to be_allowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end
  end

  context 'when an epic is in an internal group' do
    let(:group) { create(:group, :internal) }

    it 'non loged user can not read epics' do
      expect(permissions(nil, group))
        .to be_disallowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'user who is not a group memper can only read epics' do
      expect(permissions(user, group)).to be_allowed(:read_epic)
      expect(permissions(user, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'guest group memper can only read epics' do
      group.add_guest(user)

      expect(permissions(user, group)).to be_allowed(:read_epic)
      expect(permissions(user, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'reporter group memper can manage epics' do
      group.add_reporter(user)

      expect(permissions(user, group))
        .to be_allowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end
  end

  context 'when an epic is in a public group' do
    let(:group) { create(:group, :public) }

    it 'non loged user can only read epics' do
      expect(permissions(nil, group)).to be_allowed(:read_epic)
      expect(permissions(nil, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'user who is not a group memper can only read epics' do
      expect(permissions(user, group)).to be_allowed(:read_epic)
      expect(permissions(user, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'guest group memper can only read epics' do
      group.add_guest(user)

      expect(permissions(user, group)).to be_allowed(:read_epic)
      expect(permissions(user, group)).to be_disallowed(:update_epic, :destroy_epic, :admin_epic, :create_epic)
    end

    it 'reporter group memper can manage epics' do
      group.add_reporter(user)

      expect(permissions(user, group))
        .to be_allowed(:read_epic, :update_epic, :destroy_epic, :admin_epic, :create_epic)
    end
  end
end
