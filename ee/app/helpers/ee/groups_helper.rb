# frozen_string_literal: true

module EE
  module GroupsHelper
    extend ::Gitlab::Utils::Override

    def group_epics_count(state:)
      EpicsFinder
        .new(current_user, group_id: @group.id, state: state)
        .execute(skip_visibility_check: true)
        .count
    end

    def group_nav_link_paths
      %w[saml_providers#show usage_quotas#index billings#index]
    end

    def group_settings_nav_link_paths
      if ::Feature.disabled?(:group_administration_nav_item, @group)
        super + group_nav_link_paths
      else
        super
      end
    end

    def group_administration_nav_link_paths
      group_nav_link_paths
    end

    def size_limit_message_for_group(group)
      show_lfs = group.lfs_enabled? ? 'and their respective LFS files' : ''

      "Repositories within this group #{show_lfs} will be restricted to this maximum size. Can be overridden inside each project. 0 for unlimited. Leave empty to inherit the global value."
    end

    override :group_packages_nav_link_paths
    def group_packages_nav_link_paths
      %w[
        groups/packages#index
        groups/dependency_proxies#show
        groups/container_registries#index
      ]
    end

    override :group_packages_nav?
    def group_packages_nav?
      super || group_dependency_proxy_nav?
    end

    def group_dependency_proxy_nav?
      @group.dependency_proxy_feature_available?
    end

    def group_path_params(group)
      { group_id: group }
    end

    override :remove_group_message
    def remove_group_message(group)
      return super unless group.feature_available?(:adjourned_deletion_for_projects_and_groups)

      date = permanent_deletion_date(Time.now.utc)

      _("The contents of this group, its subgroups and projects will be permanently removed after %{deletion_adjourned_period} days on %{date}. After this point, your data cannot be recovered.") %
        { date: date, deletion_adjourned_period: deletion_adjourned_period }
    end

    def permanent_deletion_date(date)
      (date + deletion_adjourned_period.days).strftime('%F')
    end

    def deletion_adjourned_period
      ::Gitlab::CurrentSettings.deletion_adjourned_period
    end

    def show_discover_group_security?(group)
      security_feature_available_at = DateTime.new(2019, 11, 1)

      !!current_user &&
        ::Gitlab.com? &&
        current_user.created_at > security_feature_available_at &&
        !@group.feature_available?(:security_dashboard) &&
        can?(current_user, :admin_group, @group) &&
        current_user.ab_feature_enabled?(:discover_security)
    end

    def show_group_activity_analytics?
      can?(current_user, :read_group_activity_analytics, @group)
    end

    def show_usage_quotas_in_sidebar?
      License.feature_available?(:usage_quotas)
    end

    def show_billing_in_sidebar?
      ::Gitlab::CurrentSettings.should_check_namespace_plan?
    end

    def show_administration_nav?(group)
      ::Feature.enabled?(:group_administration_nav_item, group) &&
      group.parent.nil? &&
      can?(current_user, :admin_group, group)
    end

    def administration_nav_path(group)
      if show_saml_in_sidebar?(group)
        group_saml_providers_path(group)
      elsif show_usage_quotas_in_sidebar?
        group_usage_quotas_path(group)
      elsif show_billing_in_sidebar?
        group_billings_path(group)
      end
    end

    def show_delayed_project_removal_setting?(group)
      group.feature_available?(:adjourned_deletion_for_projects_and_groups)
    end

    private

    def get_group_sidebar_links
      links = super

      if can?(current_user, :read_group_cycle_analytics, @group)
        links << :cycle_analytics
      end

      if can?(current_user, :read_group_merge_request_analytics, @group)
        links << :merge_request_analytics
      end

      if can?(current_user, :read_group_contribution_analytics, @group) || show_promotions?
        links << :contribution_analytics
      end

      if can?(current_user, :read_epic, @group)
        links << :epics
      end

      if @group.feature_available?(:issues_analytics)
        links << :analytics
      end

      if @group.insights_available?
        links << :group_insights
      end

      if @group.feature_available?(:productivity_analytics) && can?(current_user, :view_productivity_analytics, @group)
        links << :productivity_analytics
      end

      if ::Feature.enabled?(:group_iterations, @group, default_enabled: true) && @group.feature_available?(:iterations) && can?(current_user, :read_iteration, @group)
        links << :iterations
      end

      links
    end
  end
end
