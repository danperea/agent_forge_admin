class CrewConfiguration
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :id, :integer
  attribute :crew_type, :string
  attribute :name, :string
  attribute :description, :string
  attribute :agents, :object, default: []
  attribute :is_active, :boolean
  attribute :configuration, :object
  attribute :executions_count, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  def self.all
    response = api_client.get_crew_configurations
    return [] unless response.success?

    response.parsed_response.map { |crew_data| new(crew_data) }
  end

  def self.find(id)
    response = api_client.get_crew_configuration(id)
    return nil unless response.success?

    new(response.parsed_response)
  end

  def self.create(attributes)
    crew = new(attributes)
    crew.save
    crew
  end

  def save
    crew_attributes = attributes.except('id', 'executions_count', 'created_at', 'updated_at')

    if id.present?
      response = api_client.update_crew_configuration(id, crew_attributes)
    else
      response = api_client.create_crew_configuration(crew_attributes)
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

    response = api_client.delete_crew_configuration(id)
    response.success?
  end

  def persisted?
    id.present?
  end

  def status_badge
    is_active? ? '✅ Active' : '⏸️ Inactive'
  end

  def agents_count
    agents.is_a?(Array) ? agents.length : 0
  end

  def agents_summary
    return "No agents" if agents_count == 0

    "#{agents_count} agent#{'s' if agents_count != 1}"
  end

  def crew_executions
    return [] unless id.present?

    CrewExecution.where(crew_configuration_id: id)
  end

  private

  def self.api_client
    @api_client ||= AgentForgeApiClient.new
  end

  def api_client
    self.class.api_client
  end
end