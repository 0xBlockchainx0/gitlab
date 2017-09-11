class Board < ActiveRecord::Base
  prepend EE::Board

  belongs_to :project

  has_many :lists, -> { order(:list_type, :position) }, dependent: :delete_all # rubocop:disable Cop/ActiveRecordDependent

<<<<<<< HEAD
  validates :name, presence: true

=======
>>>>>>> ce/10-0-stable
  validates :project, presence: true, if: :project_needed?

  def project_needed?
    true
  end
<<<<<<< HEAD
=======

  def parent
    project
  end

  def group_board?
    false
  end
>>>>>>> ce/10-0-stable

  def backlog_list
    lists.merge(List.backlog).take
  end

  def closed_list
    lists.merge(List.closed).take
  end
end
