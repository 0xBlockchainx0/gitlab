module Boards
  class ListService < Boards::BaseService
<<<<<<< HEAD
    prepend EE::Boards::ListService

=======
>>>>>>> ce/10-0-stable
    def execute
      create_board! if parent.boards.empty?
      parent.boards
    end

    private

    def create_board!
      Boards::CreateService.new(parent, current_user).execute
    end
  end
end
