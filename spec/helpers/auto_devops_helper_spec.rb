require 'spec_helper'

describe AutoDevopsHelper do
  set(:project) { create(:project) }
  set(:user) { create(:user) }

  describe '.show_auto_devops_callout?' do
    let(:allowed) { true }

    before do
      allow(helper).to receive(:can?).with(user, :admin_pipeline, project) { allowed }
      allow(helper).to receive(:current_user) { user }
    end

    subject { helper.show_auto_devops_callout?(project) }

    context 'when all conditions are met' do
      it { is_expected.to eq(true) }
    end

    context 'when dismissed' do
      before do
        helper.request.cookies[:auto_devops_settings_dismissed] = 'true'
      end

      it { is_expected.to eq(false) }
    end

    context 'when user cannot admin project' do
      let(:allowed) { false }

      it { is_expected.to eq(false) }
    end

    context 'when auto devops is enabled system-wide' do
      before do
        stub_application_setting(auto_devops_enabled: true)
      end

      it { is_expected.to eq(false) }
    end

    context 'when auto devops is explicitly enabled for project' do
      before do
        project.create_auto_devops!(enabled: true)
      end

      it { is_expected.to eq(false) }
    end

    context 'when auto devops is explicitly disabled for project' do
      before do
        project.create_auto_devops!(enabled: false)
      end

      it { is_expected.to eq(false) }
    end
  end
end
