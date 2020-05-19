# frozen_string_literal: true

require 'spec_helper'

describe BuildArtifactEntity do
  let(:job) { create(:ci_build, :artifacts, name: 'test:job', artifacts_expire_at: 1.hour.from_now) }

  let(:entity) do
    described_class.new(job, request: double)
  end

  describe '#as_json' do
    subject { entity.as_json }

    it 'contains job name' do
      expect(subject[:name]).to eq 'test:job'
    end

    it 'exposes information about expiration of artifacts' do
      expect(subject).to include(:expired, :expire_at)
    end

    it 'contains paths to the artifacts' do
      expect(subject[:path])
        .to include "jobs/#{job.id}/artifacts/download?file_type=archive"

      expect(subject[:keep_path])
        .to include "jobs/#{job.id}/artifacts/keep?file_type=archive"

      expect(subject[:browse_path])
        .to include "jobs/#{job.id}/artifacts/browse?file_type=archive"
    end
  end
end
