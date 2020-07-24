# frozen_string_literal: true

module Types
  # rubocop: disable Graphql/AuthorizeTypes
  class VulnerableProjectsByGradeType < BaseObject
    graphql_name 'VulnerableProjectsByGrade'
    description 'Represents vulnerability letter grades with associated projects'

    field :grade, Types::VulnerabilityGradeEnum, null: false,
          description: "Grade based on the highest severity vulnerability present"

    field :projects, Types::ProjectType.connection_type, null: false,
          description: 'Projects within this grade',
          authorize: :read_project
  end
  # rubocop: enable Graphql/AuthorizeTypes
end
