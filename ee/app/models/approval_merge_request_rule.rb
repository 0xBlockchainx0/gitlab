# frozen_string_literal: true

class ApprovalMergeRequestRule < ApplicationRecord
  include ApprovalRuleLike

  DEFAULT_NAME_FOR_CODE_OWNER = 'Code Owner'

  scope :regular, -> { where(code_owner: false) }
  scope :code_owner, -> { where(code_owner: true) } # special code owner rules, updated internally when code changes

  belongs_to :merge_request

  # approved_approvers is only populated after MR is merged
  has_and_belongs_to_many :approved_approvers, class_name: 'User', join_table: :approval_merge_request_rules_approved_approvers
  has_one :approval_merge_request_rule_source
  has_one :approval_project_rule, through: :approval_merge_request_rule_source

  def project
    merge_request.target_project
  end

  # Users who are eligible to approve, including specified group members.
  # Excludes the author if 'self-approval' isn't explicitly
  # enabled on project settings.
  # @return [Array<User>]
  def approvers
    scope = super

    if merge_request.author && !project.merge_requests_author_approval?
      scope = scope.where.not(id: merge_request.author)
    end

    scope
  end

  def sync_approved_approvers
    # Before being merged, approved_approvers are dynamically calculated in ApprovalWrappedRule instead of being persisted.
    return unless merge_request.merged?

    self.approved_approver_ids = merge_request.approvals.map(&:user_id) & approvers.map(&:id)
  end
end
