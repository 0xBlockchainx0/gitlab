class AddMirrorAvailableToApplicationSettings < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_column_with_default(:application_settings, :mirror_available, :boolean, default: true, allow_null: false) unless column_exists?(:application_settings, :mirror_available)
  end

  def down
<<<<<<< HEAD
    # ee/db/migrate/20171017125928_add_remote_mirror_available_to_application_settings.rb will remove the column.
=======
    remove_column(:application_settings, :mirror_available) if column_exists?(:application_settings, :mirror_available)
>>>>>>> 632244e7ad4a77dc5bf7ef407812b875d20569bb
  end
end
