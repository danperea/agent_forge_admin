class AgentTask
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :id, :integer
  attribute :project_id, :integer
  attribute :agent_type, :string
  attribute :title, :string
  attribute :description, :string
  attribute :status, :string
  attribute :priority, :string
  attribute :input_data, :string
  attribute :output_data, :string
  attribute :assigned_at, :datetime
  attribute :completed_at, :datetime
  attribute :error_message, :string
  attribute :estimated_duration, :integer
  attribute :interactions_count, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  def self.all
    # Get all tasks across all projects
    all_tasks = []
    Project.all.each do |project|
      response = api_client.get_agent_tasks(project.id)
      if response.success?
        project_tasks = response.parsed_response.map do |task_data|
          task_data['project_id'] = project.id
          new(task_data)
        end
        all_tasks.concat(project_tasks)
      end
    end
    all_tasks
  end

  def self.where(conditions = {})
    if conditions[:project_id]
      response = api_client.get_agent_tasks(conditions[:project_id])
      return [] unless response.success?

      response.parsed_response.map do |task_data|
        task_data['project_id'] = conditions[:project_id]
        new(task_data)
      end
    else
      all
    end
  end

  def self.find(id)
    # We need project_id to find a specific task
    # This is a limitation of the API structure
    all_tasks = all
    all_tasks.find { |task| task.id == id.to_i }
  end

  def self.create(attributes)
    task = new(attributes)
    task.save
    task
  end

  def save
    return false unless project_id.present?

    task_attributes = attributes.except('id', 'project_id', 'created_at', 'updated_at')

    if id.present?
      response = api_client.update_agent_task(project_id, id, task_attributes)
    else
      response = api_client.create_agent_task(project_id, task_attributes)
    end

    if response.success?
      data = response.parsed_response
      self.id = data['id'] if data['id']
      true
    else
      false
    end
  end

  def execute!
    return false unless id.present? && project_id.present?

    response = api_client.execute_agent_task(project_id, id)
    response.success?
  end

  def persisted?
    id.present?
  end

  def project
    @project ||= Project.find(project_id) if project_id.present?
  end

  def status_badge
    case status
    when 'completed'
      '✅ Completed'
    when 'in_progress'
      '🔄 In Progress'
    when 'failed'
      '❌ Failed'
    else
      '⏸️ Pending'
    end
  end

  def priority_badge
    case priority
    when 'high'
      '🔴 High'
    when 'medium'
      '🟡 Medium'
    when 'low'
      '🟢 Low'
    else
      '⚪ Normal'
    end
  end

  private

  def self.api_client
    @api_client ||= AgentForgeApiClient.new
  end

  def api_client
    self.class.api_client
  end
end