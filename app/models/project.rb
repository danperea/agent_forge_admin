class Project
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :id, :integer
  attribute :name, :string
  attribute :description, :string
  attribute :status, :string
  attribute :repository_url, :string
  attribute :github_owner, :string
  attribute :github_repo, :string
  attribute :confluence_space, :string
  attribute :jira_project, :string
  attribute :tech_stack, :string, array: true, default: []
  attribute :progress_percentage, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :stats, :object

  def self.all
    response = api_client.get_projects
    return [] unless response.success?

    response.parsed_response.map { |project_data| new(project_data) }
  end

  def self.find(id)
    response = api_client.get_project(id)
    return nil unless response.success?

    new(response.parsed_response)
  end

  def self.create(attributes)
    project = new(attributes)
    project.save
    project
  end

  def save
    project_attributes = attributes.except('id', 'stats', 'created_at', 'updated_at')

    if id.present?
      response = api_client.update_project(id, project_attributes)
    else
      response = api_client.create_project(project_attributes)
    end

    if response.success?
      data = response.parsed_response
      self.id = data['id'] if data['id']
      true
    else
      false
    end
  end

  def destroy
    return false unless id.present?

    response = api_client.delete_project(id)
    response.success?
  end

  def persisted?
    id.present?
  end

  def tech_stack_display
    tech_stack.join(', ') if tech_stack.present?
  end

  def agent_tasks
    return [] unless id.present?

    AgentTask.where(project_id: id)
  end

  def artifacts
    return [] unless id.present?

    Artifact.where(project_id: id)
  end

  def crew_executions
    return [] unless id.present?

    CrewExecution.where(project_id: id)
  end

  def workflow_executions
    return [] unless id.present?

    WorkflowExecution.where(project_id: id)
  end

  private

  def self.api_client
    @api_client ||= AgentForgeApiClient.new
  end

  def api_client
    self.class.api_client
  end
end