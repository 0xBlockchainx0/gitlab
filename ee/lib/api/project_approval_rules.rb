# frozen_string_literal: true

module API
  class ProjectApprovalRules < ::Grape::API
    before { authenticate! }

    ARRAY_COERCION_LAMBDA = ->(val) { val.empty? ? [] : Array.wrap(val) }

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end
    resource :projects, requirements: ::API::API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      segment ':id/approval_rules' do
        desc 'Get all project approval rules' do
          detail 'This feature was introduced in 11.6'
          success EE::API::Entities::ProjectApprovalRules
        end
        get do
          authorize! :create_merge_request_in, user_project

          present user_project, with: EE::API::Entities::ProjectApprovalRules, current_user: current_user
        end

        desc 'Create new approval rule' do
          detail 'This feature was introduced in 11.6'
          success EE::API::Entities::ApprovalRule
        end
        params do
          requires :name, type: String, desc: 'The name of the approval rule'
          requires :approvals_required, type: Integer, desc: 'The number of required approvals for this rule'
          optional :users, as: :user_ids, type: Array, coerce_with: ARRAY_COERCION_LAMBDA, desc: 'The user ids for this rule'
          optional :groups, as: :group_ids, type: Array, coerce_with: ARRAY_COERCION_LAMBDA, desc: 'The group ids for this rule'
        end
        post do
          authorize! :admin_project, user_project

          result = ::ApprovalRules::CreateService.new(user_project, current_user, declared_params(include_missing: false)).execute

          if result[:status] == :success
            present result[:rule], with: EE::API::Entities::ApprovalRule, current_user: current_user
          else
            render_api_error!(result[:message], 400)
          end
        end

        segment ':approval_rule_id' do
          desc 'Update approval rule' do
            detail 'This feature was introduced in 11.6'
            success EE::API::Entities::ApprovalRule
          end
          params do
            requires :approval_rule_id, type: Integer, desc: 'The ID of an approval_rule'
            optional :name, type: String, desc: 'The name of the approval rule'
            optional :approvals_required, type: Integer, desc: 'The number of required approvals for this rule'
            optional :users, as: :user_ids, type: Array, coerce_with: ARRAY_COERCION_LAMBDA, desc: 'The user ids for this rule'
            optional :groups, as: :group_ids, type: Array, coerce_with: ARRAY_COERCION_LAMBDA, desc: 'The group ids for this rule'
          end
          put do
            authorize! :admin_project, user_project

            params = declared_params(include_missing: false)
            puts params.inspect
            approval_rule = user_project.approval_rules.find(params.delete(:approval_rule_id))
            result = ::ApprovalRules::UpdateService.new(approval_rule, current_user, params).execute

            if result[:status] == :success
              present result[:rule], with: EE::API::Entities::ApprovalRule, current_user: current_user
            else
              render_api_error!(result[:message], 400)
            end
          end

          desc 'Delete an approval rule' do
            detail 'This feature was introduced in 11.6'
          end
          params do
            requires :approval_rule_id, type: Integer, desc: 'The ID of an approval_rule'
          end
          delete do
            authorize! :admin_project, user_project

            approval_rule = user_project.approval_rules.find(params[:approval_rule_id])
            destroy_conditionally!(approval_rule)

            no_content!
          end
        end
      end
    end
  end
end
