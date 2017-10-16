module EE
  module BoardsHelper
    def parent
      @group || @project
    end

    def board_data
      data = {
        board_milestone_title: board&.milestone&.title,
        focus_mode_available: parent.feature_available?(:issue_board_focus_mode).to_s,
        show_promotion: (@project && show_promotions? && (!@project.feature_available?(:multiple_issue_boards) || !@project.feature_available?(:issue_board_milestone) || !@project.feature_available?(:issue_board_focus_mode))).to_s

      }

      super.merge(data)
    end

    def build_issue_link_base
      return super unless @board.group_board?

      "#{group_path(@board.group)}/:project_path/issues"
    end

    def board_base_url
      if board.group_board?
        group_boards_url(@group)
      else
        super
      end
    end

    def current_board_path(board)
      @current_board_path ||= begin
        if board.group_board?
          group_board_path(current_board_parent, board)
        else
          super(board)
        end
      end
    end

    def current_board_parent
      @current_board_parent ||= @group || super
    end

    def can_admin_issue?
      can?(current_user, :admin_issue, current_board_parent)
    end

    def board_list_data
      super.merge(group_path: @group&.path)
    end

    def board_sidebar_user_data
      super.merge(group_id: @group&.id)
    end

    def boards_link_text
      if @project.multiple_issue_boards_available?(current_user)
        s_("IssueBoards|Boards")
      else
        s_("IssueBoards|Board")
      end
    end
  end
end
