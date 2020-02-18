# frozen_string_literal: true

module QA
  module Page
    module Project
      module Settings
        class CICD < Page::Base
          include Common

          view 'app/views/projects/settings/ci_cd/show.html.haml' do
            element :autodevops_settings_content
            element :deploy_tokens_settings
            element :runners_settings_content
            element :variables_settings_content
          end

          def expand_runners_settings(&block)
            expand_section(:runners_settings_content) do
              Settings::Runners.perform(&block)
            end
          end

          def expand_ci_variables(&block)
            expand_section(:variables_settings_content) do
              Settings::CiVariables.perform(&block)
            end
          end

          def expand_deploy_tokens(&block)
            expand_section(:deploy_tokens_settings) do
              DeployTokens.perform(&block)
            end
          end

          def expand_auto_devops(&block)
            expand_section(:autodevops_settings_content) do
              Settings::AutoDevops.perform(&block)
            end
          end
        end
      end
    end
  end
end

QA::Page::Project::Settings::CICD.prepend_if_ee('QA::EE::Page::Project::Settings::CICD')
