class AddRemoteMirrorAvailableOverriddenToProjects < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_column(:projects, :remote_mirror_available_overridden, :boolean) unless column_exists?(:projects, :remote_mirror_available_overridden)
  end

  def down
<<<<<<< HEAD
    # ee/db/migrate/20171017130239_add_remote_mirror_available_overridden_to_projects_ee.rb will remove the column.
=======
    remove_column(:projects, :remote_mirror_available_overridden) if column_exists?(:projects, :remote_mirror_available_overridden)
>>>>>>> 632244e7ad4a77dc5bf7ef407812b875d20569bb
  end
end
