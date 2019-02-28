# frozen_string_literal: true

require 'spec_helper'

describe Epics::DateSourcingMilestonesFinder do
  describe '#execute' do
    let(:project) { create(:project) }

    it 'returns date and id from milestones' do
      epic = create(:epic)
      milestone1 = create(:milestone, start_date: Date.new(2000, 1, 1), due_date: Date.new(2000, 1, 10), project: project)
      milestone2 = create(:milestone, due_date: Date.new(2000, 1, 30), project: project)
      milestone3 = create(:milestone, start_date: Date.new(2000, 1, 1), due_date: Date.new(2000, 1, 20), project: project)
      create(:issue, epic: epic, milestone: milestone1, project: project)
      create(:issue, epic: epic, milestone: milestone2, project: project)
      create(:issue, epic: epic, milestone: milestone3, project: project)

      results = described_class.new(epic.id)

      expect(results).to have_attributes(
        start_date: milestone1.start_date,
        start_date_sourcing_milestone_id: milestone1.id,
        due_date: milestone2.due_date,
        due_date_sourcing_milestone_id: milestone2.id
      )
    end

    it 'returns date and id from single milestone' do
      epic = create(:epic)
      milestone1 = create(:milestone, start_date: Date.new(2000, 1, 1), due_date: Date.new(2000, 1, 10), project: project)
      create(:issue, epic: epic, milestone: milestone1, project: project)

      results = described_class.new(epic.id)

      expect(results).to have_attributes(
        start_date: milestone1.start_date,
        start_date_sourcing_milestone_id: milestone1.id,
        due_date: milestone1.due_date,
        due_date_sourcing_milestone_id: milestone1.id
      )
    end

    it 'returns date and id from milestone without date' do
      epic = create(:epic)
      milestone1 = create(:milestone, start_date: Date.new(2000, 1, 1), project: project)
      create(:issue, epic: epic, milestone: milestone1, project: project)

      results = described_class.new(epic.id)

      expect(results).to have_attributes(
        start_date: milestone1.start_date,
        start_date_sourcing_milestone_id: milestone1.id,
        due_date: nil,
        due_date_sourcing_milestone_id: nil
      )
    end

    it 'handles epics without milestone' do
      epic = create(:epic)

      results = described_class.new(epic.id)

      expect(results).to have_attributes(
        start_date: nil,
        start_date_sourcing_milestone_id: nil,
        due_date: nil,
        due_date_sourcing_milestone_id: nil
      )
    end
  end
end
