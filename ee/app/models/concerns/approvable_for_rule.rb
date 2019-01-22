# frozen_string_literal: true

module ApprovableForRule
  FORWARDABLE_METHODS = %w{
    approval_needed?
    approved?
    approvals_left
    can_approve?
    has_approved?
    any_approver_allowed?
    authors_can_approve?
  }.freeze

  FORWARDABLE_METHODS.each do |method|
    define_method(method) do |*args|
      return super(*args) if ::Feature.disabled?(:approval_rule)

      approval_state.public_send(method, *args) # rubocop:disable GitlabSecurity/PublicSend
    end
  end

  def approvers_overwritten?
    return super if ::Feature.disabled?(:approval_rule)

    approval_state.approval_rules_overwritten?
  end
end
