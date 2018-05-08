module Ci
  class PipelinePresenter < Gitlab::View::Presenter::Delegated
<<<<<<< HEAD
    prepend ::EE::Ci::PipelinePresenter
=======
>>>>>>> 632244e7ad4a77dc5bf7ef407812b875d20569bb
    include Gitlab::Utils::StrongMemoize

    FAILURE_REASONS = {
      config_error: 'CI/CD YAML configuration error!'
    }.merge(EE_FAILURE_REASONS)

    presents :pipeline

    def failed_builds
      return [] unless can?(current_user, :read_build, pipeline)

      strong_memoize(:failed_builds) do
        pipeline.builds.latest.failed
      end
    end

    def failure_reason
      return unless pipeline.failure_reason?

      FAILURE_REASONS[pipeline.failure_reason.to_sym] ||
        pipeline.failure_reason
    end

    def status_title
      if auto_canceled?
        "Pipeline is redundant and is auto-canceled by Pipeline ##{auto_canceled_by_id}"
      end
    end
  end
end
